class Student
  # Метод initialize задає початкові значення для об'єкта
  def initialize(name, age, major)
    @name = name
    @age = age
    @major = major
  end

  # Метод для виведення інформації про студента
  def introduce
    puts "Hi, I'm #{@name}, I'm #{@age} years old, and I study #{@major}."
  end

  # Метод для оновлення спеціальності
  def change_major(new_major)
    @major = new_major
    puts "#{@name} has changed their major to #{@major}."
  end
end

# Створення об'єктів класу Student
student1 = Student.new("Vika", 20, "Computer Science")
student2 = Student.new("Andriy", 22, "Physics")

# Виклик методів
student1.introduce
student2.introduce
student1.change_major("Mathematics")