require 'test/unit'
require 'Match'

class MatchTest < Test::Unit::TestCase

  def test_compile_simple_string
    [ "a", "abc def", "úñícode" ].each do |s|
      m = TRegex::Match.new s
      assert_equal s, m.to_regexp
    end
  end

end
