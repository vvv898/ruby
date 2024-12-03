require 'thread'

# Клас для управління багатопотоковим записом у файл
class FileWriter
  def initialize(file_name)
    @file_name = file_name
    @mutex = Mutex.new
    clear_file
  end

  # Метод для очищення файлу
  def clear_file
    File.open(@file_name, "w") { |file| file.truncate(0) }
  end

  # Метод для запису даних у файл з блокуванням
  def write_data(thread_name, content, times)
    times.times do |i|
      @mutex.synchronize do
        File.open(@file_name, "a") do |file|
          file.puts("#{thread_name}: #{content} - Запис #{i + 1}")
        end
      end
      sleep(rand(0.1..0.5)) # Імітація затримки
    end
  end
end

#=begin
# Приклад використання (закоментуйте, якщо запускаєте тести)

 if __FILE__ == $PROGRAM_NAME
   writer = FileWriter.new("shared_file.txt")
   threads = []
   data = [
     { name: "Потік 1", content: "Дані від потоку 1" },
     { name: "Потік 2", content: "Дані від потоку 2" },
     { name: "Потік 3", content: "Дані від потоку 3" }
   ]

   data.each do |entry|
     threads << Thread.new { writer.write_data(entry[:name], entry[:content], 5) }
   end

   threads.each(&:join)
   puts "Запис завершено. Перевірте файл shared_file.txt."
 end