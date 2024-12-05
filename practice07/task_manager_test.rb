require 'minitest/autorun'
require 'date'
require_relative 'task_manager'

class TaskManagerTest < Minitest::Test
  def setup
    @manager = TaskManager.new
    @manager.instance_variable_set(:@tasks, [])
    @manager.stub(:save_tasks, nil) {} # Заглушка для збереження у файл
  end

  def test_add_task
    # Імітуємо ввід для додавання задачі
    input = ["Test Task", "2024-12-31"]
    @manager.stub(:gets, -> { input.shift }) do
      assert_output(/Задачу додано!/) { @manager.send(:add_task) }
      tasks = @manager.instance_variable_get(:@tasks)
      assert_equal 1, tasks.size
      assert_equal 'Test Task', tasks.first[:title]
      assert_equal '2024-12-31', tasks.first[:deadline]
      assert_equal false, tasks.first[:completed]
    end
  end

  def test_add_task_invalid_title
    # Імітуємо спробу додати задачу з порожньою назвою
    input = ["", "Valid Title", "2024-12-31"]
    @manager.stub(:gets, -> { input.shift }) do
      assert_output(/Назва задачі не може бути порожньою/) { @manager.send(:add_task) }
      tasks = @manager.instance_variable_get(:@tasks)
      assert_equal 1, tasks.size
      assert_equal 'Valid Title', tasks.first[:title]
    end
  end

  def test_add_task_invalid_date
    # Імітуємо спробу додати задачу з некоректною датою
    input = ["Test Task", "2024-34-67", "2024-12-31"]
    @manager.stub(:gets, -> { input.shift }) do
      assert_output(/Невірний формат дати/) { @manager.send(:add_task) }
      tasks = @manager.instance_variable_get(:@tasks)
      assert_equal 1, tasks.size
      assert_equal '2024-12-31', tasks.first[:deadline]
    end
  end

  def test_delete_task
    # Імітуємо видалення задачі
    @manager.instance_variable_set(:@tasks, [{ id: 1, title: 'Test Task', deadline: '2024-12-31', completed: false }])
    input = ["1"]
    @manager.stub(:gets, -> { input.shift }) do
      assert_output(/Задачу видалено!/) { @manager.send(:delete_task) }
      tasks = @manager.instance_variable_get(:@tasks)
      assert_empty tasks
    end
  end

  def test_delete_task_invalid_id
    # Спроба видалити неіснуючу задачу
    @manager.instance_variable_set(:@tasks, [{ id: 1, title: 'Test Task', deadline: '2024-12-31', completed: false }])
    input = ["2"]
    @manager.stub(:gets, -> { input.shift }) do
      assert_output(/Задачу видалено!/) { @manager.send(:delete_task) }
      tasks = @manager.instance_variable_get(:@tasks)
      assert_equal 1, tasks.size
    end
  end

  def test_edit_task
    # Імітуємо редагування задачі
    @manager.instance_variable_set(:@tasks, [{ id: 1, title: 'Old Task', deadline: '2024-12-31', completed: false }])
    input = ["1", "New Task", "2025-01-01", "yes"]
    @manager.stub(:gets, -> { input.shift }) do
      assert_output(/Задачу оновлено!/) { @manager.send(:edit_task) }
      task = @manager.instance_variable_get(:@tasks).first
      assert_equal 'New Task', task[:title]
      assert_equal '2025-01-01', task[:deadline]
      assert_equal true, task[:completed]
    end
  end

  def test_edit_task_invalid_id
    # Спроба редагувати неіснуючу задачу
    @manager.instance_variable_set(:@tasks, [{ id: 1, title: 'Old Task', deadline: '2024-12-31', completed: false }])
    input = ["2"]
    @manager.stub(:gets, -> { input.shift }) do
      assert_output(/Задачу не знайдено!/) { @manager.send(:edit_task) }
      task = @manager.instance_variable_get(:@tasks).first
      assert_equal 'Old Task', task[:title]
    end
  end

  def test_list_tasks
    # Відображення списку задач
    @manager.instance_variable_set(:@tasks, [
      { id: 1, title: 'Task 1', deadline: '2024-12-31', completed: false },
      { id: 2, title: 'Task 2', deadline: '2025-01-01', completed: true }
    ])
    assert_output(/Task 1.*Task 2/) { @manager.send(:list_tasks) }
  end

  def test_filter_tasks_completed
    # Фільтрація завершених задач
    @manager.instance_variable_set(:@tasks, [
      { id: 1, title: 'Task 1', deadline: '2024-12-31', completed: true },
      { id: 2, title: 'Task 2', deadline: '2025-01-01', completed: false }
    ])
    input = ["completed"]
    @manager.stub(:gets, -> { input.shift }) do
      assert_output(/Task 1/) { @manager.send(:filter_tasks) }
    end
  end

  def test_filter_tasks_overdue
    # Фільтрація прострочених задач
    @manager.instance_variable_set(:@tasks, [
      { id: 1, title: 'Task 1', deadline: '2022-12-31', completed: false },
      { id: 2, title: 'Task 2', deadline: '2025-01-01', completed: false }
    ])
    input = ["overdue"]
    @manager.stub(:gets, -> { input.shift }) do
      assert_output(/Task 1/) { @manager.send(:filter_tasks) }
    end
  end

  def test_filter_tasks_upcoming
    # Фільтрація майбутніх задач
    @manager.instance_variable_set(:@tasks, [
      { id: 1, title: 'Task 1', deadline: '2025-12-31', completed: false },
      { id: 2, title: 'Task 2', deadline: '2022-12-31', completed: false }
    ])
    input = ["upcoming"]
    @manager.stub(:gets, -> { input.shift }) do
      assert_output(/Task 1/) { @manager.send(:filter_tasks) }
    end
  end
end