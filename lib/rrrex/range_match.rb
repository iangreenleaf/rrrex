require 'rrrex/match'
require 'rrrex/single_atom_match'
module Rrrex
  class RangeMatch < Match
   include SingleAtomMatch
    def initialize( range )
      @range = range
    end

    def to_regexp_string
      wrap "[#{@range.first}-#{@range.last}]"
    end
  end
end
