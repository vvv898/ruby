def divide_matrix(matrix, block_size, direction=:horizontal)
  rows = matrix.length
  cols = matrix[0].length

  pieces = []

  if direction == :horizontal
    # Перевіряємо, чи можна розділити на горизонтальні блоки
    return 'Неможливо розділити горизонтально' unless rows % block_size == 0

    (0...rows).step(block_size) do |i|
      block = matrix[i, block_size]
      raisin_count = block.flatten.count('o')

      # Перевіряємо, чи в кожному блоці є рівно одна родзинка
      if raisin_count != 1
        return "Неможливо розділити: у блоці з рядків #{i}–#{i+block_size-1} кількість родзинок не дорівнює 1"
      end

      pieces << block
    end
  elsif direction == :vertical
    # Перевіряємо, чи можна розділити на вертикальні блоки
    return 'Неможливо розділити вертикально' unless cols % block_size == 0

    (0...cols).step(block_size) do |i|
      block = matrix.map { |row| row[i, block_size] }  # Вибираємо стовпці
      raisin_count = block.flatten.count('o')

      # Перевіряємо, чи в кожному блоці є рівно одна родзинка
      if raisin_count != 1
        return "Неможливо розділити: у блоці з стовпців #{i}–#{i+block_size-1} кількість родзинок не дорівнює 1"
      end

      pieces << block
    end
  end

  pieces
end

def divide_with_flexibility(matrix)
  # Пробуємо розділити на горизонтальні блоки по 2 рядки
  result = divide_matrix(matrix, 2, :horizontal)

  if result.is_a?(String)  # Якщо не вдалося, пробуємо на 1 рядок
    puts "Не вдалося розділити горизонтально на 2 рядки. Пробуємо на 1 рядок..."
    result = divide_matrix(matrix, 1, :horizontal)
  end

  if result.is_a?(String)  # Якщо не вдалося розділити горизонтально, пробуємо вертикально
    puts "Не вдалося розділити горизонтально. Пробуємо вертикально на 2 стовпці..."
    result = divide_matrix(matrix, 2, :vertical)
  end

  if result.is_a?(String)  # Якщо не вдалося на 2 стовпці, пробуємо на 1 стовпець
    puts "Не вдалося розділити вертикально на 2 стовпці. Пробуємо на 1 стовпець..."
    result = divide_matrix(matrix, 1, :vertical)
  end

  result
end

# Приклад використання
matrix = [
  ['.', '.', '.', 'o'],
  ['.', '.', '.', '.'],
  ['.', '.', 'o', '.'],
  ['o', 'o', '.', '.'],
  ['.', '.', '.', '.'],
  ['.', '.', '.', '.'],
]

result = divide_with_flexibility(matrix)
puts result.is_a?(String) ? result : result.map { |piece| piece.inspect }.join("\n")