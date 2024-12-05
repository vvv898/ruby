# csv_builder.rb
require 'csv'

class CSVBuilder
  attr_reader :headers, :rows

  def initialize
    @headers = []
    @rows = []
  end

  def header(*columns)
    @headers = columns
  end

  def row(*values)
    if values.size != @headers.size
      raise ArgumentError, "Кількість значень у рядку має відповідати кількості заголовків"
    end

    @rows << values
  end

  def generate(file_path)
    CSV.open(file_path, "wb") do |csv|
      csv << @headers  # Пишемо заголовки без лапок
      @rows.each { |row| csv << row }  # Пишемо дані без лапок
    end
  end
end