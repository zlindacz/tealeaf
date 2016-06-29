# Linda Zhang
# Email: zlindacz@gmail.com
# Github: https://github.com/zlindacz/course1_lesson2.git

# Tic Tac Toe Game

require 'colorize'

class Board
  attr_accessor :data

  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]
  
  def initialize
    @data = {}
    (1..9).each { |position| @data[position] = " " }
  end

  def empty_positions
    data.select { |_position, value| value == " " }.keys
  end

  def full?
    empty_positions.empty?
  end

  def mark!(position, marker)
    data[position] = marker
  end

  def win?(marker)
    WINNING_LINES.each do |combo|
      return true if data.values_at(*combo).count(marker) == 3
    end
    false
  end

  def display
    system 'clear'
    puts 'Tic Tac Toe'
    puts
    puts " #{data[1]} | #{data[2]} | #{data[3]}     1 | 2 | 3 "
    puts '---+---+---    --+---+-- '
    puts " #{data[4]} | #{data[5]} | #{data[6]}     4 | 5 | 6 "
    puts '---+---+---    --+---+-- '
    puts " #{data[7]} | #{data[8]} | #{data[9]}     7 | 8 | 9 "
  end
end

class Player
  attr_reader :name
  attr_accessor :marker, :color

  def initialize(name, marker)
    @name = name
    @marker = marker
    @color = color
  end

  def choose_color
    begin
      puts 'You can pick a color for your pieces.'
      puts '1). Red, 2). Green, 3). Yellow, 4). Blue, 5). Magenta, 6). Cyan, 7). White'
      chosen_color = gets.chomp.to_i
    end until Game::COLORS.keys.include?(chosen_color)
    self.color = Game::COLORS.values_at(chosen_color).first
    self.marker = marker.colorize(color.to_sym)
    return color
  end
end

class Computer < Player

  def initialize(name, marker)
    super
  end

  def choose_color(player_color)
    self.color = Game::COLORS.select { |key, color| color != player_color }.values.sample
    self.marker = marker.colorize(color.to_sym)
  end
end

class Game
  attr_accessor :current_player

  COLORS = {1 => 'light_red', 2 => 'light_green', 3 => 'light_yellow', 4 => 'light_blue',
            5 => 'light_magenta', 6 => 'light_cyan', 7 => 'light_white'}

  def initialize
    @board = Board.new
    @you = Player.new('You', 'x')
    @computer = Computer.new('Computer', 'o')
    @current_player = current_player
  end

  def two_in_a_row(marker)
    possible_moves = []
    Board::WINNING_LINES.each do |combo|
      if @board.data.values_at(*combo).count(marker) == 2 && @board.data.values_at(*combo).count(' ') == 1
        possible_moves << combo.select { |position| @board.data[position] == ' ' }
      end
    end
    possible_moves.sample
  end

  def fill_or_block_row
    if two_in_a_row(@computer.marker)
      @board.mark!(two_in_a_row(@computer.marker).first, @computer.marker)
    elsif two_in_a_row(@you.marker)
      @board.mark!(two_in_a_row(@you.marker).first, @computer.marker)
    else
      false
    end
  end

  def current_player_move!
    if current_player == @you
      begin
        puts "Pick a square to place your piece. #{@board.empty_positions}"
        player_position = gets.chomp.to_i
      end until @board.empty_positions.include?(player_position)
      @board.mark!(player_position, @you.marker)
      @current_player = @computer
    else
      if fill_or_block_row
      else
        @board.mark!(@board.empty_positions.sample, @computer.marker)
      end
      @current_player = @you
    end
  end

  def display_winner
    if @board.win?(@you.marker)
      puts 'You win!'
      return true
    elsif @board.win?(@computer.marker)
      puts 'Computer wins.'
      return true
    elsif @board.full?
      puts "It's a tie."
      return true
    end
  end

  def play_again?
    initialize
    puts 'Would you like to play again? <n to quit>'
    play until gets.chomp.downcase == 'n'
    puts 'Thank you for playing Tic Tac Toe!'
    exit
  end

  def play
    @board.display
    puts 'Would you like to go first? <y/n>'
    gets.chomp.downcase == 'y' ? @current_player = @you : @current_player = @computer
    your_color = @you.choose_color
    @computer.choose_color(your_color)
    begin
      @board.display
      current_player_move!
      @board.display
    end until display_winner
    play_again?
  end
end

game = Game.new.play