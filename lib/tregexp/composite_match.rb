require 'tregexp/composite_match'
module TRegexp
  module CompositeMatch
    def initialize(*args)
      @atoms = args.collect do |a|
        input a
      end
    end

    def group_names
      @atoms.inject( [] ) do |memo,a|
        memo + a.group_names
      end
    end
  end
end
