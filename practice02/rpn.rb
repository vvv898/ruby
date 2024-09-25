PRIORITY = {
  '+' => 1,
  '-' => 1,
  '*' => 2,
  '/' => 2
}

def number?(token)
  token =~ /\d/
end

def operator?(token)
  PRIORITY.key?(token)
end

def infix_to_rpn(expression)
  outputresult = []
  operators = []

  tokens = expression.scan(/\d+|\S/)

  tokens.each do |token|
    if number?(token)
      outputresult << token
    elsif operator?(token)
      while !operators.empty? && PRIORITY[operators.last] && PRIORITY[operators.last] >= PRIORITY[token]
        outputresult << operators.pop
      end
      operators << token
    elsif token == '('
      operators.push(token)
    elsif token == ')'
      while operators.last != '('
        outputresult << operators.pop
      end
      operators.pop
    end
  end

  while !operators.empty?
    outputresult << operators.pop
  end

  outputresult.join(' ')
end

puts "Enter an expression (example: 12 + 2 * ((3 * 4) + (10 / 5))):"
expression = gets.chomp

puts "RPN: #{infix_to_rpn(expression)}"