require 'minitest/autorun'
require_relative 'knapsack'

class TestKnapsack < Minitest::Test
  def test_standard_case
    weights = [2, 3, 4, 5]
    values = [3, 4, 5, 6]
    capacity = 5

    knapsack = Knapsack.new(weights, values, capacity)
    max_value, selected_items = knapsack.solve

    assert_equal 7, max_value
    assert_equal [1, 0], selected_items.sort
  end

  def test_zero_capacity
    weights = [1, 2, 3]
    values = [10, 20, 30]
    capacity = 0

    knapsack = Knapsack.new(weights, values, capacity)
    max_value, selected_items = knapsack.solve

    assert_equal 0, max_value
    assert_empty selected_items
  end

  def test_all_items_fit
    weights = [1, 1, 1]
    values = [10, 20, 30]
    capacity = 3

    knapsack = Knapsack.new(weights, values, capacity)
    max_value, selected_items = knapsack.solve

    assert_equal 60, max_value
    assert_equal [0, 1, 2], selected_items.sort
  end

  def test_equal_weights_and_values
    weights = [2, 2, 2]
    values = [5, 5, 5]
    capacity = 4

    knapsack = Knapsack.new(weights, values, capacity)
    max_value, selected_items = knapsack.solve

    assert_equal 10, max_value
    assert_equal 2, selected_items.length
  end

  def test_empty_items
    weights = []
    values = []
    capacity = 10

    knapsack = Knapsack.new(weights, values, capacity)
    max_value, selected_items = knapsack.solve

    assert_equal 0, max_value
    assert_empty selected_items
  end
end