require 'rrrex/composite_match'
module Rrrex
  module CompositeMatch
    def group_names
      @atoms.inject( [] ) do |memo,a|
        memo + a.group_names
      end
    end
  end
end
