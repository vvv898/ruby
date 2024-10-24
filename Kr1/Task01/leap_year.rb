def leap_year(year)
  if year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)
    "#{year} is a leap year"
  else
    "#{year} is not a leap year"
  end
end

def valid_year?(input)
  input.to_i.to_s == input && input.to_i > 0
end

#puts "Enter year:"
#input = gets.chomp
#
#if valid_year?(input)
#  year = input.to_i
#  puts leap_year(year)
#else
#  puts "Invalid input. Please enter a positive integer."
#end