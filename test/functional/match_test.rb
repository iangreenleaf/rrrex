require 'test/unit'
require 'rubygems'
require 'mocha'
require 'Match'

class MatchTest < Test::Unit::TestCase

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
    "foobar".rmatch? do "oo" end
  end

  def test_match_simple_string_inline
    assert_match "oo", "foobar" do s "oo" end
  end

  def test_dont_match_simple_string_inline
    assert_no_match "foobar" do s "xy" end
  end

  def test_special_characters_escaped_in_string
    assert_no_match "foobar" do s "o+" end
    assert_match "o+", "+hello+" do "o+" end
  end

  def test_match_or
    assert_match "foo", "foobar" do "xy".or "foo" end
  end

  def test_match_any
    assert_match "", "foobar" do s("o").any end
    assert_match "aaaaa", "aaaaab" do s("a").any end
    assert_match "fo", "foobar" do s("fo").any end
    assert_match "abab", "ababaab" do s("ab").any end
  end

  def test_match_concat
    assert_match "foobar", "foobar" do "foo" + "bar" end
    assert_match "foobarbaz", "foobarbazbar" do "foo" + "bar" + "baz" end
  end

  def test_grouping
    assert_match "foobar", "foobar" do "foo" + ( "xyz".or "bar" ) end
    assert_match "bar", "foobar" do ( "xyz" + "foo" ).or "bar" end
    assert_match "fo", "foobar" do ( "xyz" + "foo" ).or( "xyz".or "fo" ).or( "foo" + "xyz" ) end
  end

  def test_dont_add_extra_backreferences
    mdata = "foobar".rmatch? do "foo" + ( "xyz".or "bar" ) end
    assert_equal 1, mdata.length
  end

  def assert_no_match( string, &block )
    assert_nil( string.rmatch?( &block ) )
  end

  def assert_match( expected, string, &block )
    assert( matches = string.rmatch?( &block ) )
    assert_equal expected, matches[0]
  end

end
