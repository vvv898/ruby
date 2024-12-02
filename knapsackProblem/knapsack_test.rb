require 'minitest/autorun'
require_relative 'knapsackProblem'

class KnapsackTest < Minitest::Test
  # Набір основних даних
  def setup
    @weights = [1, 2, 3, 2, 5]
    @values = [10, 70, 30, 40, 50]
    @capacity = 10
    @n = @weights.size
  end
  
  # Тест для нульової потужності рюкзака
  def test_zero_capacity
    result_recursive = knapsack_recursive(@n, 0, @weights, @values)
    result_dp = knapsack_dp(@n, 0, @weights, @values)
    # Перевіряє, що результат дорівнює 0
    assert_equal 0, result_recursive, 'Рекурсивний алгоритм не обробив нульову потужність'
    assert_equal 0, result_dp, 'Динамічне програмування не обробило нульову потужність'
  end

  # Тест для порожнього списку предметів
  def test_empty_items
    weights = []
    values = []
    result_recursive = knapsack_recursive(0, @capacity, weights, values)
    result_dp = knapsack_dp(0, @capacity, weights, values)
    # Перевіряє, що результат дорівнює 0
    assert_equal 0, result_recursive, 'Рекурсивний алгоритм не обробив порожній список предметів'
    assert_equal 0, result_dp, 'Динамічне програмування не обробило порожній список предметів'
  end

  # Тест для випадку, коли всі предмети занадто важкі
  def test_all_items_too_heavy
    weights = [5, 6, 7]
    values = [10, 20, 30]
    capacity = 3
    result_recursive = knapsack_recursive(weights.size, capacity, weights, values)
    result_dp = knapsack_dp(weights.size, capacity, weights, values)
    # Перевіряє, що результат дорівнює 0
    assert_equal 0, result_recursive, 'Рекурсивний алгоритм не обробив випадок із занадто важкими предметами'
    assert_equal 0, result_dp, 'Динамічне програмування не обробило випадок із занадто важкими предметами'
  end

  # Тест для випадку, коли всі предмети поміщаються в рюкзак
  def test_all_items_fit
    weights = [1, 2, 3]
    values = [10, 20, 30]
    capacity = 6
    result_recursive = knapsack_recursive(weights.size, capacity, weights, values)
    result_dp = knapsack_dp(weights.size, capacity, weights, values)
    # Перевіряє, що результат дорівнює сумі всіх цінностей
    assert_equal 60, result_recursive, 'Рекурсивний алгоритм не обробив випадок, коли всі предмети поміщаються'
    assert_equal 60, result_dp, 'Динамічне програмування не обробило випадок, коли всі предмети поміщаються'
  end

  # Тест для випадку, коли всі предмети однакові
  def test_items_with_same_weight_and_value
    weights = [2, 2, 2]
    values = [10, 10, 10]
    capacity = 4
    result_recursive = knapsack_recursive(weights.size, capacity, weights, values)
    result_dp = knapsack_dp(weights.size, capacity, weights, values)
    # Перевіряє, що обирається оптимальна комбінація
    assert_equal 20, result_recursive, 'Рекурсивний алгоритм не обробив предмети з однаковими властивостями'
    assert_equal 20, result_dp, 'Динамічне програмування не обробило предмети з однаковими властивостями'
  end
end
