class Student
  # Метод initialize задає початкові значення для об'єкта
  def initialize(name, age, major)
    @name = name
    @age = age
    @major = major
  end

  # Гетери
  def name
    @name
  end

  def age
    @age
  end

  def major
    @major
  end

  # Сетери
  def name=(new_name)
    @name = new_name
  end

  def age=(new_age)
    @age = new_age
  end

  def major=(new_major)
    @major = new_major
  end
end

# Створення об'єктів класу Student
student1 = Student.new("Vika", 20, "Computer Science")
student2 = Student.new("Andriy", 22, "Physics")

# Використання гетера для читання даних
puts "Student 1's name is #{student1.name} and they are #{student1.age} years old."

# Використання сетера для оновлення віку
student2.age = 23
puts "#{student2.name} is now #{student2.age} years old."