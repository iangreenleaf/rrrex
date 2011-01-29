module TRegexp
  class Match
  end
end
require 'tregexp/regexp'
require 'tregexp/string_match'
require 'tregexp/range_match'
require 'tregexp/or_match'
require 'tregexp/concat_match'
require 'tregexp/not_match'
module TRegexp
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
end
