require 'rrrex/match'
require 'rrrex/single_atom_match'
module Rrrex
  class GroupMatch < Regin::Group
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
