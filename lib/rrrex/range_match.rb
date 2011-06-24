require 'rrrex/match'
require 'rrrex/single_atom_match'
module Rrrex
  class RangeMatch < Regin::CharacterClass
   include SingleAtomMatch
    def initialize( range )
      super "#{@range.first}-#{@range.last}"
    end
  end
end
