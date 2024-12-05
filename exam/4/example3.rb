class MyClass
  define_method(:dynamic_method) do |name| # Використання define_method
    "Hello, #{name}!"
  end
end

obj = MyClass.new
puts obj.dynamic_method("Vika")