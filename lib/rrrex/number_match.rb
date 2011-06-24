require 'rrrex/match'
require 'rrrex/single_atom_match'
module Rrrex
  class NumberMatch < Regin::Group
    include SingleAtomMatch
    def initialize( a, min, max, opts={} )
      # Subtle: when nil, we want min to convert to 0, but max to convert to ""
      super a, :quantifier => "{#{@min.to_i},#{@max}}"
      @opts = { :greedy => true }.merge opts
      @min = min
      @max = max
    end

    def to_regexp_string
      re_str = atom.to_regexp_string + "{#{@min.to_i},#{@max}}"
      re_str += "?" unless @opts[ :greedy ]
      wrap re_str
    end
  end
end
