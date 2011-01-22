module TRegex

  WORD_CHAR = '\w'
  DIGIT = '\d'
  WHITESPACE = '\s'
  LETTER = '[[:alpha:]]'
  ANY_CHAR = '.'

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

  def self.group( name_or_atom=nil, atom=nil )
    if name_or_atom.kind_of? Symbol
      name = name_or_atom
      atom = atom
    elsif name_or_atom.kind_of? Hash
      name = name_or_atom.keys.first
      atom = name_or_atom[ name ]
    else
      name = nil
      atom = name_or_atom
    end
    GroupMatch.new atom, name
  end

  class Regexp < ::Regexp
    def initialize( r )
      super r.to_regexp_string
      @atom = r
    end

    def match( str )
      result = super( str )
      MatchData.new @atom, result unless result.nil?
    end
  end

  class MatchData
    def initialize( atom, match_data )
      @atom = atom
      @match_data = match_data
    end

    def []( i )
      if i.is_a? Symbol
        named_groups[ i ]
      else
        @match_data[ i ]
      end
    end

    def named_groups
      @named_groups ||=
        begin
          result = {}
          names = @atom.group_names
          names.each_index do |i|
            result[ names[ i ] ] = @match_data[ i ]
          end
          result
        end
    end

    def to_a
      @match_data.to_a
    end

    def method_missing( name, *args )
      @match_data.send name, *args
    end
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
      Regexp.new( self ).match str
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

    def group_names
      []
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

    def group_names
      []
      @atom.group_names if @atom.respond_to? :group_names
    end
  end

  module CompositeMatch
    def initialize(*args)
      @atoms = args.collect do |a|
        input a
      end
    end

    def group_names
      @atoms.collect do |a|
        a.group_names
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

  class GroupMatch < Match
   include SingleAtomMatch
   def initialize atom, name
     @name = name
     super atom
   end

   def to_regexp_string
     "(#{atom.to_regexp_string})"
   end

   def group_names
     names = @atom.group_names || []
     names.unshift @name
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
