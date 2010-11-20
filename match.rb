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

module TRegex

  def self.s(str)
    StringMatch.new str
  end

  def self.any r
    AnyMatch.new r
  end

  class Match
    def self.convert( atom )
      atom.kind_of?( Match ) ? atom : StringMatch.new( atom )
    end

    def group( s )
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
      group atom.to_regexp_string
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
      group Regexp.escape atom
    end
  end

  class OrMatch < Match
   include CompositeMatch
    def to_regexp_string
      group @atoms.map {|p| p.to_regexp_string }.join "|"
    end
  end

  class ConcatMatch < Match
   include CompositeMatch
    def to_regexp_string
      group @atoms.map {|p| p.to_regexp_string }.join ""
    end
  end

  class AnyMatch < Match
   include SingleAtomMatch
    def to_regexp_string
      group atom.to_regexp_string + "*"
    end
  end
end
