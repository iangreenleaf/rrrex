module Rrrex
  class Match
  end
end
require 'rrrex/regexp'
require 'rrrex/string_match'
require 'rrrex/range_match'
require 'rrrex/or_match'
require 'rrrex/concat_match'
require 'rrrex/not_match'
module Rrrex
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
