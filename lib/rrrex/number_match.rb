require 'rrrex/match'
require 'rrrex/single_atom_match'
module Rrrex
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
