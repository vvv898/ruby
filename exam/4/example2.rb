class MyClass
  def greet
    "Hello!"
  end
end

# Використання alias
class MyClass
  alias original_greet greet

  def greet
    "#{original_greet} How are you?"
  end
end

obj = MyClass.new
puts obj.greet