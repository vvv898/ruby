require 'json'
require 'date'

class TaskManager
  DATA_FILE = 'tasks.json'.freeze

  def initialize
    @tasks = load_tasks
  end

  def run
    loop do
      display_menu
      choice = gets.chomp.to_i

      case choice
      when 1 then add_task
      when 2 then delete_task
      when 3 then edit_task
      when 4 then list_tasks
      when 5 then filter_tasks
      when 6 then save_tasks
      when 7 then break
      else puts 'Невірний вибір, спробуйте ще раз.'
      end
    end
  end

  private

  def display_menu
    puts "\n=== Меню ==="
    puts "1. Додати задачу"
    puts "2. Видалити задачу"
    puts "3. Редагувати задачу"
    puts "4. Переглянути всі задачі"
    puts "5. Фільтрувати задачі"
    puts "6. Зберегти задачі"
    puts "7. Вийти"
    print "\nВаш вибір: "
  end

  def valid_date?(date_string)
    Date.iso8601(date_string)
    true
  rescue ArgumentError
    false
  end

  def add_task
    print 'Введіть назву задачі: '
    title = gets.chomp
    while title.strip.empty?
      puts 'Назва задачі не може бути порожньою. Спробуйте ще раз.'
      print 'Введіть назву задачі: '
      title = gets.chomp
    end

    print 'Введіть дедлайн (yyyy-mm-dd): '
    deadline = gets.chomp
    while !valid_date?(deadline)
      puts 'Невірний формат дати. Будь ласка, введіть дату у форматі yyyy-mm-dd.'
      print 'Введіть дедлайн (yyyy-mm-dd): '
      deadline = gets.chomp
    end

    @tasks << { id: next_id, title: title, deadline: deadline, completed: false }
    puts 'Задачу додано!'
  end

  def delete_task
    print 'Введіть ID задачі для видалення: '
    id = gets.chomp.to_i
    @tasks.reject! { |task| task[:id] == id }
    puts 'Задачу видалено!'
  end

  def edit_task
    print 'Введіть ID задачі для редагування: '
    id = gets.chomp.to_i
    task = @tasks.find { |t| t[:id] == id }
    if task
      print 'Введіть нову назву задачі (або Enter, щоб залишити): '
      new_title = gets.chomp
      print 'Введіть новий дедлайн (yyyy-mm-dd, або Enter, щоб залишити): '
      new_deadline = gets.chomp
      print 'Позначити як виконану? (yes/no): '
      completed = gets.chomp.downcase == 'yes'

      task[:title] = new_title unless new_title.empty?
      task[:deadline] = new_deadline unless new_deadline.empty?
      task[:completed] = completed
      puts 'Задачу оновлено!'
    else
      puts 'Задачу не знайдено!'
    end
  end

  def list_tasks
    if @tasks.empty?
      puts 'Немає задач для відображення.'
    else
      puts "\n=== Список задач ==="
      @tasks.each do |task|
        puts "ID: #{task[:id]}, Назва: #{task[:title]}, Дедлайн: #{task[:deadline]}, Виконано: #{task[:completed]}"
      end
    end
  end

  def filter_tasks
    print 'Фільтрувати за (completed/overdue/upcoming): '
    filter = gets.chomp.downcase

    filtered_tasks = case filter
                     when 'completed'
                       @tasks.select { |task| task[:completed] }
                     when 'overdue'
                       today = Date.today
                       @tasks.select { |task| Date.parse(task[:deadline]) < today && !task[:completed] }
                     when 'upcoming'
                       today = Date.today
                       @tasks.select { |task| Date.parse(task[:deadline]) >= today }
                     else
                       puts 'Невірний фільтр!'
                       return
                     end

    if filtered_tasks.empty?
      puts 'Немає задач для відображення.'
    else
      puts "\n=== Відфільтровані задачі ==="
      filtered_tasks.each do |task|
        puts "ID: #{task[:id]}, Назва: #{task[:title]}, Дедлайн: #{task[:deadline]}, Виконано: #{task[:completed]}"
      end
    end
  end

  def save_tasks
    File.write(DATA_FILE, JSON.pretty_generate(@tasks))
    puts 'Задачі збережено!'
  end

  def load_tasks
    if File.exist?(DATA_FILE)
      JSON.parse(File.read(DATA_FILE), symbolize_names: true)
    else
      []
    end
  end

  def next_id
    @tasks.empty? ? 1 : @tasks.max_by { |task| task[:id] }[:id] + 1
  end
end

# Запуск програми
TaskManager.new.run