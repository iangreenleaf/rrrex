class String
  def plus_with_regexp( str2 )
    if str2.kind_of? TRegex::Match
      TRegex::StringMatch.new( self ) + str2
    else
      self.plus_without_regexp str2
    end
  end
  alias_method :plus_without_regexp, :+
  alias_method :+, :plus_with_regexp

  def method_missing_with_regexp( name, *args, &block )
    if [ :or, :and ].include? name
      TRegex::StringMatch.new( self ).send name, *args
    else
      method_missing_without_regexp name, *args, &block
    end
  end
  alias_method :method_missing_without_regexp, :method_missing
  alias_method :method_missing, :method_missing_with_regexp

  def rmatch?( &block )
    pattern = TRegex::Match.convert TRegex.module_exec &block
    pattern.match self
  end
end

class Fixnum
  def exactly( atom )
    TRegex::NumberMatch.new atom, self, self
  end

  def or_more( atom )
    TRegex::NumberMatch.new atom, self, nil
  end

  def or_less( atom )
    TRegex::NumberMatch.new atom, nil, self
  end
end

class Range
  def of( atom )
    TRegex::NumberMatch.new atom, self.begin, self.end
  end
end

module TRegex

  WORD_CHAR = '\w'

  def self.any r
    NumberMatch.new r, 0, nil
  end

  def self.some r
    NumberMatch.new r, 1, nil
  end

  def self.word_char
    UnescapedStringMatch.new WORD_CHAR
  end

  class Match
    def self.convert( atom )
      atom.kind_of?( Match ) ? atom : StringMatch.new( atom )
    end

    def wrap( s )
      "(?:#{s})"
    end

    def match(str)
      Regexp.new( to_regexp_string ).match str
    end

    def or(atom)
      OrMatch.new self, atom
    end

    def +(p)
      ConcatMatch.new self, p
    end

    protected
    def input( atom )
      self.class.convert atom
    end
  end

  module SingleAtomMatch

    attr_reader :atom

    def initialize( a )
      self.atom = a
    end

    def atom=( a )
      @atom = input a
    end

    def to_regexp_string
      wrap atom.to_regexp_string
    end
  end

  module CompositeMatch
    def initialize(*args)
      @atoms = args.collect do |a|
        input a
      end
    end
  end

  class StringMatch < Match
   include SingleAtomMatch
    def initialize( a )
      @atom = a
    end

    def to_regexp_string
      wrap Regexp.escape atom
    end
  end

  class UnescapedStringMatch < StringMatch
    def to_regexp_string
      wrap atom
    end
  end

  class OrMatch < Match
   include CompositeMatch
    def to_regexp_string
      wrap @atoms.map {|p| p.to_regexp_string }.join "|"
    end
  end

  class ConcatMatch < Match
   include CompositeMatch
    def to_regexp_string
      wrap @atoms.map {|p| p.to_regexp_string }.join ""
    end
  end

  class NumberMatch < Match
    include SingleAtomMatch
    def initialize( a, min, max )
      super a
      @min = min
      @max = max
    end

    def to_regexp_string
      # Subtle: when nil, we want min to convert to 0, but max to convert to ""
      wrap atom.to_regexp_string + "{#{@min.to_i},#{@max}}"
    end
  end
end
