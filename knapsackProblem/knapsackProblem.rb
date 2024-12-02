# Наївний рекурсивний алгоритм
def knapsack_recursive(n, c, weights, values)
  return 0 if n == 0 || c == 0 # Базовий випадок

  if weights[n - 1] > c
    # Пропускаємо поточний елемент, якщо його вага більша за потужність рюкзака
    knapsack_recursive(n - 1, c, weights, values)
  else
    # Обчислюємо максимум: включити або не включати поточний елемент
    exclude_item = knapsack_recursive(n - 1, c, weights, values)
    include_item = values[n - 1] + knapsack_recursive(n - 1, c - weights[n - 1], weights, values)
    [exclude_item, include_item].max
  end
end

# Динамічне програмування
def knapsack_dp(n, c, weights, values)
  # Ініціалізація таблиці
  dp = Array.new(n + 1) { Array.new(c + 1, 0) }

  (1..n).each do |i|
    (0..c).each do |j|
      if weights[i - 1] > j
        dp[i][j] = dp[i - 1][j] # Пропускаємо елемент
      else
        exclude_item = dp[i - 1][j]
        include_item = values[i - 1] + dp[i - 1][j - weights[i - 1]]
        dp[i][j] = [exclude_item, include_item].max
      end
    end
  end

  dp[n][c]
end

# Приклад використання
weights = [1, 2, 3, 2, 5]  # Ваги предметів
values = [10, 70, 30, 40, 50] # Цінність предметів
capacity = 10 # Потужність рюкзака
n = weights.size

puts "Результат (рекурсія): #{knapsack_recursive(n, capacity, weights, values)}"
puts "Результат (динамічне програмування): #{knapsack_dp(n, capacity, weights, values)}"