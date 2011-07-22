require 'method_missing_conversion'
require 'rrrex/string_match'
require 'rrrex/match'
require 'rrrex/dsl_context'
class String
  include MethodMissingConversion
  sends_methods_to [ :or ], Rrrex::StringMatch

  def plus_with_regexp( str2 )
    if str2.kind_of? Regin::Expression
      Rrrex::StringMatch.new( self ) + str2
    else
      self.plus_without_regexp str2
    end
  end
  alias_method :plus_without_regexp, :+
  alias_method :+, :plus_with_regexp

  def rmatch?( &block )
    pattern = Rrrex::Match.convert Rrrex::DslContext.module_exec &block
    pattern.match self
  end
end
