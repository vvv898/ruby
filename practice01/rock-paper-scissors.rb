if ARGV.length != 2
  puts "Будь ласка, вкажіть по одному виборі для обох гравців."
  exit
end

first_player = ARGV[0].downcase
second_player = ARGV[1].downcase

puts "Вибір першого гравця: #{first_player}"
puts "Вибір другого гравця: #{second_player}"

choices = ['камінь', 'ножиці', 'папір']

if !choices.include?(first_player) || !choices.include?(second_player)
  puts "Неправильний вибір. Будь ласка, виберіть камінь, ножиці або папір."
  exit
end

if first_player == second_player
  puts "Нічия!"
elsif (first_player == 'камінь' && second_player == 'ножиці') ||
      (first_player == 'ножиці' && second_player == 'папір') ||
      (first_player == 'папір' && second_player == 'камінь')
  puts "Переміг перший гравець!"
else
  puts "Переміг другий гравець!"
end