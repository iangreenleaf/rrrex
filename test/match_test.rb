require 'test/unit'
require 'rubygems'
require 'mocha'
require 'rrrex'

class MatchTest < Test::Unit::TestCase

  def test_match_simple_string
    [ ["a", "a"], ["bc", "babb bc"], ["úñícode", "i like úñícode"] ].each do |pattern,string|
      m = Rrrex::StringMatch.new pattern
      assert m.match string
    end
  end

  def test_dont_match_simple_string
    [ ["a", "b"], ["bc", "bac def"], ["úñícode", "i like unicode"] ].each do |pattern,string|
      m = Rrrex::StringMatch.new pattern
      assert_nil m.match string
    end
  end

  def test_inline_match_triggers_module
    rxp_stub = stub "Rrrex::Match", { :match => true }
    Rrrex::StringMatch.expects(:new).with("oo").returns(rxp_stub)
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
    assert_match "x", "x" do any "x" end
    assert_match "aaaaa", "aaaaab" do any "a" end
    assert_match "abab", "ababaab" do any "ab" end
    assert_match "", "xxxx" do any "y" end
  end

  def test_match_any_nongreedy
    assert_match "", "x" do any "x", :greedy => false end
    # WTF Ruby 1.8 bug
    #assert_match "abbbbc", "abbbbc" do "a" + any( "a", :greedy => false ) + "c" end
  end

  def test_match_some
    assert_match "x", "x" do some "x" end
    assert_match "aaaaa", "aaaaab" do some "a" end
    assert_match "abab", "ababaab" do some "ab" end
    assert_no_match "xxxx" do some "y" end
  end

  def test_match_some_nongreedy
    assert_match "a", "aaaaab" do some "a", :greedy => false end
  end

  def test_match_not
    assert_match "x", "x" do _not "y" end
    assert_no_match "x" do _not "x" end
    assert_match "cdef", "abcdefab" do some _not( "a".or "b" ) end
    assert_match "defa", "abcdefaab" do some _not( "ab".or "b".or "c" ) end
  end

  def test_match_lookahead_not
    assert_match "y", "xy" do letter.not "x" end
    assert_match "1234", "123456789" do some( digit.not "5" ) end
    assert_match "1234", "1234abc" do some( digit.not "5" ) end
    assert_match "abb", "abcabb" do ( "ab" + letter ).not "abc" end
    assert_no_match "abbbc" do "a" + ( (1..6).of "a" ).not( "aaa" ) + "c" end
    assert_match "21", "123321" do 2.or_more digit.not( "12".or "3" ) end
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

  def test_match_num_or_more_nongreedy
    assert_match "foo", "foooobar" do "f" + 2.or_more( "o", :greedy => false ) end
    assert_no_match "foobar" do 3.or_more "o", :greedy => false end
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

  def test_match_num_or_less_nongreedy
    assert_match "", "xx" do 2.or_less "x", :greedy => false end
    # WTF Ruby 1.8 bug
    #assert_match "foobar", "foobar" do "f" + 2.or_less( "o", :greedy => false ) + "bar" end
  end

  def test_range_of_matches
    assert_match "xx", "xx" do (2..4).of "x" end
    assert_match "xxx", "xxx" do (2..100).of "x" end
    assert_match "xxxx", "xxxxxxxx" do (2..4).of "x" end
    assert_no_match "foobar" do "f" + (3..4).of( "o" ) + "bar" end
    assert_no_match "foooooooobar" do "f" + (3..4).of( "o" ) + "bar" end
    assert_no_match "xxxx" do (1..100).of( "y" ) + "bar" end
  end

  def test_range_nongereedy
    assert_match "xx", "xxxx" do (2..4).of "x", :greedy => false end
  end

  def test_char_range
    assert_match "b", "b" do "a".."c" end
    assert_no_match "b" do "A".."C" end
    assert_match "abc", "abcdefg" do 1.or_more "a".."c" end
    assert_match "123", "123456789" do (1..4).of 1..3 end
    assert_match "x8", "ax87" do 1.or_more( ("q".."z").or(8..9) ) end
    assert_match "az", "az" do ("a".."c") + ("w".."z") end
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

  def test_any_characters
    assert_match "f", "foobar" do any_char end
    chars = "#\t?/\<>.,;:\"'!@\#$%^&*()[]{} bar"
    assert_match chars, chars do some any_char end
    assert_no_match "\n" do any_char end
  end

  def test_word_characters
    assert_match "f", "foobar" do word_char end
    assert_match "foo_bar2", "### foo_bar2 baz bar" do some word_char end
    assert_no_match '?/\<>.,;:"\'!@#$%^&*()[]{}' do word_char end
    assert_no_match 'a,b,c,d' do 2.or_more word_char end
  end

  def test_digit_characters
    assert_match "1", "12345" do digit end
    assert_match "654321", "### abc654321baz123" do some digit end
    assert_no_match 'abc_DEF *&".' do digit end
    assert_no_match '1,2,3' do 2.or_more digit end
  end

  def test_letter_characters
    assert_match "f", "foobar" do letter end
    assert_match "foo", "### foo_bar2 baz bar" do some letter end
    assert_no_match '?/."()123456_' do letter end
    assert_no_match 'a1b2c3' do 2.or_more letter end
  end

  def test_whitespace_characters
    assert_match " ", "    " do whitespace end
    assert_match " \t ", "### \t baz bar" do some whitespace end
    assert_no_match 'abc_123-+=().?!' do whitespace end
    assert_no_match 'a b c d' do 2.or_more whitespace end
  end

  def test_numeric_group
    assert_match_backreferences ["a", "a"], "abc" do group "a" end
    assert_match_backreferences ["ab", "a", "b"], "abc" do group( "a" ) + group( "b" ) end
    assert_match_backreferences ["ab", "ab", "b"], "abc" do group( "a" + group( "b" ) ) end
    assert_match_backreferences ["abcde", "abcde"], "abcde" do group( any word_char ) end
    assert_match_backreferences ["abcde", "e"], "abcde" do any group( word_char ) end
    assert_match_backreferences ["a", "a", nil], "abc" do group( "a" ).or group( "b" ) end
  end

  def test_named_groups
    assert_match_named_groups( { :my_a => "a" }, "abc" ) do group :my_a, "a" end
    assert_match_named_groups( { :my_b => "b" }, "abc" ) do "a" + group( :my_b, "b" ) + "c" end
    assert_match_named_groups( { :a => "a", :b => nil }, "abc" ) do group( :a, "a" ).or group( :b, "b" ) end
    assert_match_named_groups( { :a => "ab", :b => "ab" }, "abc" ) do group( :a, group( :b, "ab" ) ) end
    assert_match_named_groups( { :a => "ab", :b => "b" }, "abc" ) do group( :a, "a" + group( :b, "b" ) ) end
    assert_match_named_groups( { :word => "abcde" }, "abcde" ) do group( :word, any( word_char ) ) end
    assert_match_named_groups( { :letter => "e" }, "abcde" ) do any group( :letter, word_char ) end
  end

  def test_named_groups_block_syntax
    assert_match_named_groups( { :my_a => "a" }, "abc" ) do group :my_a do "a" end end
    assert_match_named_groups( { :my_a => "a" }, "abc" ) do group( :my_a ) { "a" } end
    assert_match_named_groups( { :full_match => "abc", :last_part => "bc" }, "abc" ) do
      group :full_match do
        "a" + group( :last_part ) do
          "bz".or "bc".or "b"
        end
      end
    end
  end

  def test_named_groups_cached
    assert( matches = "a".rmatch? do group :a, "a" end )
    Rrrex::GroupMatch.any_instance.expects( :group_names ).times( 1 ).returns( [] )
    matches[ :a ]
    matches[ :a ]
    matches.named_groups
    matches.named_groups
  end

  def test_to_string
    assert_equal( "(?:(?:a)|(?:b))", Rrrex.to_s do "a".or "b" end )
  end

  def assert_no_match( string, &block )
    assert_nil( string.rmatch?( &block ) )
  end

  def assert_match( expected, string, &block )
    assert( matches = string.rmatch?( &block ) )
    assert_equal expected, matches[0]
  end

  def assert_match_backreferences( expected, string, &block )
    assert( matches = string.rmatch?( &block ) )
    assert_equal expected, matches.to_a
  end

  def assert_match_named_groups( expected, string, &block )
    assert( matches = string.rmatch?( &block ) )
    assert_equal expected, matches.named_groups
    expected.each do |k,v|
      assert_equal v, matches[ k ]
    end
  end

end
