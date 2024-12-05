class MyClass
  def greet
    "Hello!"
  end
end

# Перевизначення методу
class MyClass
  def greet
    "Hi!"
  end
end

obj = MyClass.new
puts obj.greet