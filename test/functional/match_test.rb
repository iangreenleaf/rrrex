require 'test/unit'
require 'rubygems'
require 'mocha'
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

  def test_inline_match_triggers_module
    rxp_stub = stub "TRegex::Match", { :match => true }
    TRegex::Match.expects(:new).with("oo").returns(rxp_stub)
    "foobar".rmatch do "oo" end
  end

  def test_match_simple_string_inline
    assert_match "oo", "foobar" do s "oo" end
  end

  def test_dont_match_simple_string_inline
    assert_no_match "foobar" do s "xy" end
  end

  def test_match_or
    assert_match "foo", "foobar" do s("xy").or s("foo") end
  end

  def test_match_any
    assert_match "aaaaa", "aaaaab" do s("a").any end
  end

  def test_match_concat
    assert_match "foobar", "foobar" do s("foo") + s("bar") end
  end

  def assert_no_match( string, &block )
    assert_nil( string.rmatch( &block ) )
  end

  def assert_match( expected, string, &block )
    assert( matches = string.rmatch( &block ) )
    assert_equal expected, matches[0]
  end

end
