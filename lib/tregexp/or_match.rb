require 'tregexp/match'
require 'tregexp/composite_match'
module TRegexp
  class OrMatch < Match
   include CompositeMatch
    def to_regexp_string
      wrap @atoms.map {|p| p.to_regexp_string }.join "|"
    end
  end
end
