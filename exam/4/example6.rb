obj = "Hi"

# Використання singleton_class для зміни методів об'єкта
def obj.upcase
  "Hello!"
end

puts obj.upcase