module TRegex

  WORD_CHAR = '\w'
  DIGIT = '\d'
  WHITESPACE = '\s'
  LETTER = '[[:alpha:]]'

  constants.each do |const|
    ( class << self; self; end ).instance_eval do
      define_method const.downcase.to_sym do
        UnescapedStringMatch.new const_get( const )
      end
    end
  end

  def self.any r
    NumberMatch.new r, 0, nil
  end

  def self.some r
    NumberMatch.new r, 1, nil
  end

  def self._not r
    UnescapedStringMatch.new('.').not r
  end

  class Match
    def self.convert( atom )
      if atom.kind_of? Match
        atom
      elsif atom.kind_of? Range
        RangeMatch.new atom
      else
        StringMatch.new atom
      end
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

    def not(atom)
      ConcatMatch.new NotMatch.new( atom ), self
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

  class RangeMatch < Match
   include SingleAtomMatch
    def initialize( range )
      @range = range
    end

    def to_regexp_string
      wrap "[#{@range.first}-#{@range.last}]"
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

  class NotMatch < Match
   include SingleAtomMatch
   def to_regexp_string
     "(?!#{atom.to_regexp_string})"
   end
  end
end

module MethodMissingConversion
  def self.included receiver
    receiver.extend ClassMethods
  end

  module ClassMethods
    def sends_methods_to methods, convert_to
      define_method :method_missing_helper do |name, args, block|
        if methods.include? name
          convert_to.new( self ).send name, *args
        else
          method_missing_without_regexp name, *args, &block
        end
      end
      alias_method :method_missing_without_regexp, :method_missing
      alias_method :method_missing, :method_missing_with_regexp
    end
  end

  def method_missing_with_regexp( name, *args, &block )
    method_missing_helper name, args, block
  end
end

class String
  include MethodMissingConversion
  sends_methods_to [ :or ], TRegex::StringMatch

  def plus_with_regexp( str2 )
    if str2.kind_of? TRegex::Match
      TRegex::StringMatch.new( self ) + str2
    else
      self.plus_without_regexp str2
    end
  end
  alias_method :plus_without_regexp, :+
  alias_method :+, :plus_with_regexp

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
  include MethodMissingConversion
  sends_methods_to [ :or, :+ ], TRegex::RangeMatch

  def of( atom )
    TRegex::NumberMatch.new atom, self.begin, self.end
  end
end
