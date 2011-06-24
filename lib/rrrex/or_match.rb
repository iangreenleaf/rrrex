require 'rrrex/match'
require 'rrrex/composite_match'
module Rrrex
  class OrMatch < Regin::Alternation
    include CompositeMatch
    include Match
    def to_regexp_string
      wrap( map {|p| p.to_regexp_string }.join "|" )
    end
  end
end
