require 'test/unit'
require 'Match'

class MatchTest < Test::Unit::TestCase

  def test_compile_simple_string
    [ "a", "abc def", "úñícode" ].each do |s|
      m = TRegex::Match.new s
      assert_equal s, m.to_regexp_string
    end
  end

  def test_match_simple_string
    [ ["a", "a"], ["bc", "babb bc"], ["úñícode", "i like úñícode"] ].each do |pattern,string|
      m = TRegex::Match.new pattern
      assert m.match string
    end
  end

  def test_dont_match_simple_string
    [ ["a", "b"], ["bc", "bac def"], ["úñícode", "i like unicode"] ].each do |pattern,string|
      m = TRegex::Match.new pattern
      assert_nil m.match string
    end
  end

end
