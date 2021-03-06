require 'rrrex/match_data'
module Rrrex
  class Regexp < ::Regexp
    def initialize( r )
      super r.to_regexp_string
      @atom = r
    end

    def match( str )
      result = super( str )
      MatchData.new @atom, result unless result.nil?
    end
  end
end
