class Person
  attr_accessor :name, :age

  def initialize(name, age)
    raise ArgumentError, "Name must be a non-empty string" if name.to_s.strip.empty?
    raise ArgumentError, "Age must be a non-negative integer" unless age.is_a?(Integer) && age >= 0

    @name = name
    @age = age
  end

  def age_plus_one
    @age += 1
  end

  def display_info
    puts "Name: #{@name}, Age: #{@age}"
  end
end

person = Person.new("Alex", 30)
person.display_info

person.age_plus_one
person.display_info