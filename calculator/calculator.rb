# The Persistent Calculator
# -------------------------------------------------
# Takes two numerical inputs
# Asks for the operation to be performed between them
# Displays the result
# Asks if the user has another operation to perform
#   If no, quit
# -------------------------------------------------


def say(msg)
  puts "=> #{msg}"
end

def is_numerical(number)
  number.to_i.to_s == number || number.to_f.to_s == number
end

puts 'Calculator 1.0'
puts
puts

loop do
  say 'What is the first operand?'
  num1 = gets.chomp
  until is_numerical(num1)  # checks if number is numerical
    say "#{num1} is not an integer or float. Please pick another operand."
    num1 = gets.chomp
  end

  operation = {1 => ['Add', '+'],
               2 => ['Subtract', '-'],
               3 => ['Multiply', 'x'],
               4 => ['Divide', '/']}

  say 'What operation would you like to perform?'
  operation.each {|key, value| say "#{key}) #{value[0]}"}
  my_operation = gets.chomp


  until operation.has_key?(my_operation.to_i)
    say "#{my_operation} is not a valid selection. Please choose another operation."
    my_operation = gets.chomp
  end

  say 'What is the second operand?'
  num2 = gets.chomp
  until is_numerical(num2)
    say "#{num2} is not an integer or float. Please pick another operand."
    num2 = gets.chomp
  end

  while num2.to_f == 0.0 && my_operation.to_i == 4
    say 'Cannot divide by 0! Please choose another operation.'
    my_operation = gets.chomp
    until operation.has_key?(my_operation.to_i)
      say "#{my_operation} is not a valid selection. Please choose another operation."
      my_operation = gets.chomp
    end
  end

  if num1.to_f.to_s == num1 || num2.to_f.to_s == num2   # checks if either num1 or num2 is a float
    result = case my_operation.to_i
      when 1 then num1.to_f + num2.to_f
      when 2 then num1.to_f - num2.to_f
      when 3 then num1.to_f * num2.to_f
      when 4 then num1.to_f / num2.to_f
      end
  else
    result = case my_operation.to_i
      when 1 then num1.to_i + num2.to_i
      when 2 then num1.to_i - num2.to_i
      when 3 then num1.to_i * num2.to_i
      when 4 then num1.to_i / num2.to_i
      end
  end

  say "You chose to #{operation[my_operation.to_i][0]}"
  puts
  say "#{num1} #{operation[my_operation.to_i][1]} #{num2} = #{result}."
  puts

  say "Do you want to perform another calculation? [n to quit]"
  answer = gets.chomp
  break if answer == 'n'
end

say "Thank you for using Calculator 1.0!"
