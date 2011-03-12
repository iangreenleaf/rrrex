require 'method_missing_conversion'
require 'rrrex/range_match'
class Range
  include MethodMissingConversion
  sends_methods_to [ :or, :+ ], Rrrex::RangeMatch

  def of( atom )
    Rrrex::NumberMatch.new atom, self.begin, self.end
  end
end
