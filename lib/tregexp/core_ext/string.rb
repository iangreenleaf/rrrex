require 'method_missing_conversion'
require 'tregexp/string_match'
require 'tregexp/match'
require 'tregexp/dsl_context'
class String
  include MethodMissingConversion
  sends_methods_to [ :or ], TRegexp::StringMatch

  def plus_with_regexp( str2 )
    if str2.kind_of? TRegexp::Match
      TRegexp::StringMatch.new( self ) + str2
    else
      self.plus_without_regexp str2
    end
  end
  alias_method :plus_without_regexp, :+
  alias_method :+, :plus_with_regexp

  def rmatch?( &block )
    pattern = TRegexp::Match.convert TRegexp.module_exec &block
    pattern.match self
  end
end
