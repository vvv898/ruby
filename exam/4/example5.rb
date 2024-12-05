module GreetDecorator
  def greet
    "#{super} Hi!"
  end
end

class MyClass
  def greet
    "Vika"
  end
end

# Декоратори за допомогою prepend
MyClass.prepend(GreetDecorator)

obj = MyClass.new
puts obj.greet