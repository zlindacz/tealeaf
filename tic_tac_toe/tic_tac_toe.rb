# Play the Tic Tac Toe Game

=begin
computer goes first: force-win situation

1. exclude outcomes with player piece
2. prioritize outcomes that force player into no-win
3. pick position common in both outcomes that are left

player goes first: avoid force-win

1. if player has center, take corners
2. if player has edge or corner, take center
=end

WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7],
                 [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]

def initialize_board
  board = {}
  (1..9).each { |position| board[position] = ' ' }
  board
end

def display(board)
  system 'clear'
  puts 'Tic Tac Toe'
  puts
  puts " #{board[1]} | #{board[2]} | #{board[3]} "
  puts '---+---+---'
  puts " #{board[4]} | #{board[5]} | #{board[6]} "
  puts '---+---+---'
  puts " #{board[7]} | #{board[8]} | #{board[9]} "
end

def whos_first
  puts 'You play with x. Do you want to go first? [y/n]'
  answer = gets.chomp
  answer.downcase == 'y' ? 'x' : 'o'
end

def check_empty_spaces(board)
  board.select { |_position, value| value == ' ' }.keys
end

def player_move(board)
  puts 'Place your piece on an empty square [1-9]'
  position = gets.chomp.to_i
  until check_empty_spaces(board).include? position
    puts 'That is not a valid move; please try again.'
    position = gets.chomp.to_i
  end
  board[position] = 'x'
  display(board)
end

def two_in_a_row(hsh, mrkr)
  if hsh.values.count(mrkr) == 2
    hsh.select { |_, v| v == ' ' }.keys.first
  else
    false
  end
end

def computer_two_in_a_row_move!(board)
  available_moves = Array.new(0)
  WINNING_LINES.each do |combo|
    computer = two_in_a_row(Hash[combo[0], board[combo[0]],
                                 combo[1], board[combo[1]],
                                 combo[2], board[combo[2]]], 'o')
    available_moves << computer if computer
  end
  if available_moves.any?
    board[available_moves.sample] = 'o'
    true
  else
    false
  end
end

def block_player_two_in_a_row_move!(board)
  available_moves = Array.new(0)
  WINNING_LINES.each do |combo|
    player = two_in_a_row(Hash[combo[0], board[combo[0]],
                               combo[1], board[combo[1]],
                               combo[2], board[combo[2]]], 'x')
    available_moves << player if player
  end
  if available_moves.any?
    board[available_moves.sample] = 'o'
    true
  else
    false
  end
end

# winning combinations to work with

def computer_winning_lines(board)
  winning_combos = []
  WINNING_LINES.collect do |combo|
    winning_combos << combo if board.values_at(*combo).count('x') == 0
  end
  winning_combos
end

def player_winning_lines(board)
  winning_combos = []
  WINNING_LINES.collect do |combo|
    winning_combos << combo if board.values_at(*combo).count('o') == 0
  end
  winning_combos
end

def unique_winning_lines(board)
  computer_perspective = computer_winning_lines(board) - player_winning_lines(board)
  player_perspective = player_winning_lines(board) - computer_winning_lines(board)
  sum_of_perspectives = computer_perspective + player_perspective
  return sum_of_perspectives
end

# special attacks

def computer_force_win_move!(board)
  available_moves = Hash.new(0)
  unique_winning_lines(board).each do |combo|
    next if board.values_at(*combo).count(' ') == 3
    combo.each do |position|
      available_moves[position] += 1 if board[position] == ' '
    end
  end
  if available_moves.any?
    multiple_wins = available_moves.key(available_moves.values.max)
    board[multiple_wins] = 'o'
  else
    false
  end
end

def center_or_corner_move!(board)
  position = 0
  corners = []

  position = 5 if board[5] == ' '

  if position == 0
    %w(1 3 7 9).each do |corner|
      corners << corner.to_i if board[corner.to_i] == ' '
    end
    if corners.size == 2 && board[5] == 'o'
      %w(2, 4, 6, 8).each do |side|
        position = side.to_i if board[side.to_i] == ' '
      end
    else
      position = corners.sample.to_i
    end
  end
  position > 0 ? board[position] = 'o' : false
end

# putting moves together

def computer_offensive_move!(board)
  loop do
    if computer_two_in_a_row_move!(board)
      puts 'computer two in a row offensive'
      break
    elsif block_player_two_in_a_row_move!(board)
      puts 'player two in a row offensive'
      break
    elsif computer_force_win_move!(board)
      puts 'computer force win offensive'
      break
    else
      board[check_empty_spaces(board).sample] = 'o'
      puts 'random offensive'
      break
    end
  end
  display(board)
end

def computer_defensive_move!(board)
  loop do
    if computer_two_in_a_row_move!(board)
      puts 'computer two in a row defensive'
      break
    elsif block_player_two_in_a_row_move!(board)
      puts 'player two in a row defensive'
      break
    elsif center_or_corner_move!(board)
      puts 'center or corner defensive'
      break
    elsif computer_force_win_move!(board)
      puts 'player force win defensive'
      break
    else
      board[check_empty_spaces(board).sample] = 'o'
      puts 'random defensive'
      break
    end
  end
  display(board)
end

def check_winner(board)
  WINNING_LINES.each do |combo|
    if board.values_at(*combo).count('x') == 3
      puts 'You win!'
      return true
    elsif board.values_at(*combo).count('o') == 3
      puts 'Computer wins!'
      return true
    end
  end
  nil
end

again = 'y'

while again == 'y'
  playing_board = initialize_board
  display(playing_board)
  if whos_first == 'x'
    loop do
      player_move(playing_board)
      break if check_winner(playing_board) ||
               check_empty_spaces(playing_board).empty?
      sleep 0.5
      computer_defensive_move!(playing_board)
      break if check_winner(playing_board) ||
               check_empty_spaces(playing_board).empty?
    end
  else
    position = (1..9).to_a.sample
    playing_board[position] = 'o'
    sleep 0.5
    display(playing_board)
    loop do
      player_move(playing_board)
      break if check_winner(playing_board) ||
               check_empty_spaces(playing_board).empty?
      sleep 0.5
      computer_offensive_move!(playing_board)
      break if check_winner(playing_board) ||
               check_empty_spaces(playing_board).empty?
    end
  end

  puts 'Play again? [y/n]'
  again = gets.chomp.downcase
end

puts 'Thank you for playing Tic Tac Toe!'
