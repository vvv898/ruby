operation = Proc.new { |n| n**2 }
numbers = [1, 2, 3, 4]

result = apply_operation(numbers, operation)
puts result.inspect
