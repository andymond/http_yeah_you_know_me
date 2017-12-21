require 'simplecov'
SimpleCov.start do
  add_filter "/test/"
end
require './lib/word_finder'
require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

class WordFinderTest < Minitest::Test

  def test_it_exists
    finder = WordFinder.new

    assert_instance_of WordFinder, finder
  end

  def test_it_reads_file
    finder = WordFinder.new

    assert 235886, finder.content.size
  end

  def test_contains_returns_known_for_known_word
    finder = WordFinder.new

    assert_equal "WORD is a known word", finder.contains?("word")
    assert_equal "WORD is a known word", finder.contains?("WORD")
    assert_equal "WORD is a known word", finder.contains?("WoRD")
  end

  def test_contains_returns_unknown_for_unknown_word
    finder = WordFinder.new

    assert_equal "ASDF is not a known word", finder.contains?("asdf")
    assert_equal "ASDF is not a known word", finder.contains?("Asdf")
  end

end
