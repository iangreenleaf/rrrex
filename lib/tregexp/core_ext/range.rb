require 'method_missing_conversion'
require 'tregexp/range_match'
class Range
  include MethodMissingConversion
  sends_methods_to [ :or, :+ ], TRegexp::RangeMatch

  def of( atom )
    TRegexp::NumberMatch.new atom, self.begin, self.end
  end
end
