require 'minitest/autorun'
require_relative 'D:/Desktop/ruby/gem/My_gem/lib/my_gem.rb'

class MyGemTest < Minitest::Test
  def test_sort_by_length
    input = ["apple", "kiwi", "bananana", "pearrr"]
    expected = ["kiwi", "apple", "pearrr", "bananana"]
    assert_equal expected, MyGem::Sorter.sort_by_length(input)
  end

  def test_empty_array
    input = []
    expected = []
    assert_equal expected, MyGem::Sorter.sort_by_length(input)
  end

  # Тест з однаковими довжинами рядків
  def test_equal_length_strings
    input = ["cat", "dog", "bat", "rat"]
    expected = ["cat", "dog", "bat", "rat"]
    assert_equal expected, MyGem::Sorter.sort_by_length(input)
  end

  # Тест з порожніми рядками
  def test_empty_strings
    input = ["apple", "", "kiwi", "", "banana"]
    expected = ["", "", "kiwi", "apple", "banana"]
    assert_equal expected, MyGem::Sorter.sort_by_length(input)
  end

  # Тест з одним елементом
  def test_single_element
    input = ["apple"]
    expected = ["apple"]
    assert_equal expected, MyGem::Sorter.sort_by_length(input)
  end

  # Тест з великими рядками
  def test_large_strings
    input = ["a" * 1000, "b" * 10, "c" * 500, "d" * 50]
    expected = ["b" * 10, "d" * 50, "c" * 500, "a" * 1000]
    assert_equal expected, MyGem::Sorter.sort_by_length(input)
  end
end