require 'rrrex/match'
require 'rrrex/composite_match'
module Rrrex
  class ConcatMatch < Match
   include CompositeMatch
    def to_regexp_string
      wrap @atoms.map {|p| p.to_regexp_string }.join ""
    end
  end
end
