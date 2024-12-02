class CakeDivider
  def initialize(cake)
    @cake = cake
    @cake_matrix = convert_to_matrix(cake)
  end

  def divide_cake_by_raisins
    return puts 'All rows must have the same number of elements.' unless @cake.all? { |row| row.length == @cake[0].length }

    # Розміри торта
    rows = @cake_matrix.length
    columns = @cake_matrix[0].length

    # Кількість родзинок
    raisin_count = @cake_matrix.flatten.count(0)

    # Якщо немає родзинок
    return puts 'Cannot divide the cake: no raisins.' if raisin_count.zero?

    # Площа та розмір прямокутника
    area = rows * columns
    if area % raisin_count != 0
      return puts 'Cannot divide the cake: the area is not divisible by the number of raisins.'
    end
    rect_area = area / raisin_count

    # Можливі розміри прямокутників
    possible_sizes = find_possible_sizes(rect_area)

    # Ділимо торт
    rectangles = []

    possible_sizes.each do |height, width|
      next unless rows % height == 0 && columns % width == 0

      valid = true
      (0...rows).step(height) do |r|
        (0...columns).step(width) do |c|
          rectangle = []
          raisin_count_in_rect = 0

          (0...height).each do |i|
            row = @cake_matrix[r + i][c, width]
            rectangle << row
            raisin_count_in_rect += row.count(0)
          end

          # Перевірка на кількість родзинок в прямокутнику
          if raisin_count_in_rect != 1
            valid = false
            break
          end
        end
        break unless valid
      end

      if valid
        # Зберігаємо прямокутник
        (0...rows).step(height) do |r|
          (0...columns).step(width) do |c|
            rectangle = []
            (0...height).each do |i|
              rectangle << @cake[r + i][c, width]
            end
            rectangles << rectangle
          end
        end
        break
      end
    end

    # Результати
    if rectangles.empty?
      puts 'Cannot divide the cake so that each rectangle contains one raisin.'
    else
      puts "The cake has been divided into rectangles:"
      rectangles.each_with_index do |rectangle, index|
        puts "Rectangle  #{index + 1}:"
        rectangle.each { |row| puts row }
      end
    end
  end

  private

  # Перетворюємо торт у матрицю чисел
  def convert_to_matrix(cake)
    cake.map do |row|
      row.chars.map { |cell| cell == 'о' || cell == 'o' ? 0 : 1 }
    end
  end

  # Знаходимо можливі розміри прямокутників
  def find_possible_sizes(rect_area)
    possible_sizes = []
    (2..rect_area).each do |h|
      if rect_area % h == 0
        w = rect_area / h
        possible_sizes << [h, w] if w >= 2
      end
    end
    possible_sizes
  end
end

# Введення торта
cake = [
  '.о...o..',
  '........',
  '.о......',
  '.....o..',
]

# Створюємо екземпляр класу та ділимо торт
divider = CakeDivider.new(cake)
divider.divide_cake_by_raisins