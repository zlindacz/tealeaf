# The Rock, Paper, Scissors Game

system 'clear'
player_score = 0
computer_score = 0

def point_grammar(score)
  score == 1 ? 'point' : 'points'
end

loop do
  puts "Let's play Rock, Paper, Scissors!"
  puts "Choose your hand: (R/P/S)"
  combinations = {'Rock' => {'Scissors' => true, 'Paper' => false},
                  'Scissors' => {'Paper' => true, 'Rock' => false},
                  'Paper' => {'Rock' => true, 'Scissors' => false}}

  player_hand = gets.chomp.upcase
  player_hand_word = combinations.keys.select { |key| key.start_with?(player_hand) }.first
  computer_hand_word = combinations.keys.sample

  until combinations.keys.map { |key| key[0] }.include?(player_hand)
    puts "That's an invalid selection."
    player_hand = gets.chomp.upcase
  end

  puts "You picked #{player_hand_word} and I picked #{computer_hand_word}."

  if player_hand_word == computer_hand_word
    puts "We tied!"
  elsif combinations["#{player_hand_word}"]["#{computer_hand_word}"]
    puts "You win!"
    player_score += 1
  else
    puts "You lose!"
    computer_score += 1
  end

  puts "So far, you have #{player_score} #{point_grammar(player_score)} and I have #{computer_score} #{point_grammar(computer_score)}."
  puts "Play again? [y to continue]"
  answer = gets.chomp
  system 'clear'
  break unless answer.downcase == 'y'
end

puts "You scored #{player_score} #{point_grammar(player_score)} against my #{computer_score} #{point_grammar(computer_score)}."
puts "Thank you for playing Rock, Paper, and Scissors with me!"
