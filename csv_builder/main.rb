# main.rb
require_relative 'csv_builder'

class ConfigRenderer
  def initialize(file_path)
    @file_path = file_path
    @csv_builder = CSVBuilder.new
  end

  def render
    # Читання та обробка файлу конфігурації
    File.readlines(@file_path).each do |line|
      parse_line(line.strip)
    end
  end

  private

  def parse_line(line)
    return if line.empty? || line.start_with?("#")  # Пропускаємо порожні рядки та коментарі

    if line.start_with?("header")
      parse_header(line)
    elsif line.start_with?("row")
      parse_row(line)
    else
      raise "Неочікуваний формат: #{line}"
    end
  end

  def parse_header(line)
    # Видаляємо "header" та отримуємо список колонок
    columns = line.sub('header', '').strip.split(',').map(&:strip)
    @csv_builder.header(*columns)
  end

  def parse_row(line)
    # Видаляємо "row" та отримуємо список значень
    values = line.sub('row', '').strip.split(',').map(&:strip)
    @csv_builder.row(*values)
  end
end

# Створюємо рендерер для обробки конфігураційного файлу
config_file = 'config.txt'  # Шлях до вашого конфігураційного файлу
renderer = ConfigRenderer.new(config_file)
renderer.render

# Генеруємо CSV-файл
renderer.instance_variable_get(:@csv_builder).generate('output.csv')
puts "CSV файл успішно створено!"