require 'tregexp/match'
require 'tregexp/single_atom_match'
module TRegexp
  class NotMatch < Match
   include SingleAtomMatch
   def to_regexp_string
     "(?!#{atom.to_regexp_string})"
   end
  end
end
