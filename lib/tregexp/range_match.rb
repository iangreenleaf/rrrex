require 'tregexp/match'
require 'tregexp/single_atom_match'
module TRegexp
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
