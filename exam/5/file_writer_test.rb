require 'minitest/autorun'
require_relative 'file_writer'

class FileWriterTest < Minitest::Test
  FILE_NAME = "test_file.txt"

  def setup
    @writer = FileWriter.new(FILE_NAME)
  end

  def teardown
    File.delete(FILE_NAME) if File.exist?(FILE_NAME)
  end

  def test_file_is_cleared
    File.write(FILE_NAME, "Старі дані")
    @writer.clear_file
    assert_equal "", File.read(FILE_NAME), "Файл не був очищений"
  end

  def test_write_data
    @writer.write_data("Тестовий потік", "Тестовий контент", 3)
    content = File.read(FILE_NAME)
    assert_match(/Тестовий потік: Тестовий контент - Запис 1/, content)
    assert_match(/Тестовий потік: Тестовий контент - Запис 2/, content)
    assert_match(/Тестовий потік: Тестовий контент - Запис 3/, content)
  end

  def test_multithreaded_write
    threads = []
    data = [
      { name: "Потік 1", content: "Дані від потоку 1" },
      { name: "Потік 2", content: "Дані від потоку 2" },
      { name: "Потік 3", content: "Дані від потоку 3" }
    ]

    data.each do |entry|
      threads << Thread.new { @writer.write_data(entry[:name], entry[:content], 2) }
    end
    threads.each(&:join)

    content = File.read(FILE_NAME)
    assert_match(/Потік 1: Дані від потоку 1 - Запис 1/, content)
    assert_match(/Потік 2: Дані від потоку 2 - Запис 1/, content)
    assert_match(/Потік 3: Дані від потоку 3 - Запис 1/, content)
  end
end