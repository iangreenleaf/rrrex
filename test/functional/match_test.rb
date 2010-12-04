require 'test/unit'
require 'rubygems'
require 'mocha'
require 'Match'

class MatchTest < Test::Unit::TestCase

  def test_match_simple_string
    [ ["a", "a"], ["bc", "babb bc"], ["úñícode", "i like úñícode"] ].each do |pattern,string|
      m = TRegex::StringMatch.new pattern
      assert m.match string
    end
  end

  def test_dont_match_simple_string
    [ ["a", "b"], ["bc", "bac def"], ["úñícode", "i like unicode"] ].each do |pattern,string|
      m = TRegex::StringMatch.new pattern
      assert_nil m.match string
    end
  end

  def test_inline_match_triggers_module
    rxp_stub = stub "TRegex::Match", { :match => true }
    TRegex::StringMatch.expects(:new).with("oo").returns(rxp_stub)
    "foobar".rmatch? do "oo" end
  end

  def test_match_simple_string_inline
    assert_match "oo", "foobar" do "oo" end
  end

  def test_dont_match_simple_string_inline
    assert_no_match "foobar" do "xy" end
  end

  def test_special_characters_escaped_in_string
    assert_no_match "foobar" do "o+" end
    assert_match "o+", "+hello+" do "o+" end
  end

  def test_match_or
    assert_match "foo", "foobar" do "xy".or "foo" end
  end

  def test_match_any
    assert_match "", "foobar" do any("o") end
    assert_match "aaaaa", "aaaaab" do any("a") end
    assert_match "fo", "foobar" do any("fo") end
    assert_match "abab", "ababaab" do any("ab") end
  end

  def test_match_concat
    assert_match "foobar", "foobar" do "foo" + "bar" end
    assert_match "foobarbaz", "foobarbazbar" do "foo" + "bar" + "baz" end
  end

  def test_match_num_exactly
    assert_match "oo", "foobar" do 2.exactly "o" end
    assert_match "oo", "foooobar" do 2.exactly "o" end
    assert_no_match "foobar" do 3.exactly "o" end
    assert_match "foobar", "foobar" do "f" + 2.exactly( "o" ) + "bar" end
    assert_no_match "foobar" do "f" + 1.exactly( "o" ) + "bar" end
  end

  def test_match_num_or_more
    assert_match "oo", "foobar" do 2.or_more "o" end
    assert_match "foooo", "foooobar" do "f" + 2.or_more( "o" ) end
    assert_no_match "foobar" do 3.or_more "o" end
  end

  def test_match_num_or_less
    assert_match "xx", "xx" do 2.or_less "x" end
    assert_match "xx", "xxxxxxxx" do 2.or_less "x" end
    assert_match "xx", "xx" do 100.or_less "x" end
    assert_match "foobar", "foobar" do "f" + 2.or_less( "o" ) + "bar" end
    assert_match "fbar", "fbar" do "f" + 2.or_less( "o" ) + "bar" end
    assert_no_match "foooobar" do "f" + 3.or_less( "o" ) + "bar" end
    assert_match "", "xxxxx" do 3.or_less "y" end
  end

  def test_match_range
    assert_match "xx", "xx" do (2..4).of "x" end
    assert_match "xxx", "xxx" do (2..100).of "x" end
    assert_match "xxxx", "xxxxxxxx" do (2..4).of "x" end
    assert_no_match "foobar" do "f" + (3..4).of( "o" ) + "bar" end
    assert_no_match "foooooooobar" do "f" + (3..4).of( "o" ) + "bar" end
    assert_no_match "xxxx" do (1..100).of( "y" ) + "bar" end
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
