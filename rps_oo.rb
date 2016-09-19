# Object oriented Rock, Paper, Scissors Game

class Player
  attr_accessor :hand

  def initialize
    @hand = choose_hand
  end

  def choose_hand
    begin
      puts "Choose Rock, Paper, or Scissors <r/p/s>"
      reply = gets.chomp.downcase
    end until Game::CHOICES.keys.include?(reply)
    Game::CHOICES[reply]
  end
end


class Computer
  attr_accessor :hand

  def initialize
    @hand = choose_hand
  end

  def choose_hand
    Game::CHOICES.values.sample
  end
end


class Game
  CHOICES = {'r' => 'Rock', 'p' => 'Paper' , 's' => 'Scissors'}

  attr_accessor :player, :computer, :winner

  def initialize
    @player = player
    @computer = computer
  end

  def choose_hands
    self.player = Player.new.hand
    self.computer = Computer.new.hand
  end

  def display_hands
    system 'clear'
    puts "\n\nPlayer chose #{player} and Computer chose #{computer}.\n\n"
  end

  def compare_hands
    if player == computer
      self.winner = nil
    elsif player == 'Paper' && computer == 'Rock' ||
      player == 'Rock' && computer == 'Scissors' ||
      player == 'Scissors' && computer == 'Paper'
      self.winner = 'Player'
    else
      self.winner = 'Computer'
    end
  end

  def display_message(winning_choice)
    case winning_choice
    when 'Paper' then 'Paper wraps Rock!'
    when 'Rock' then 'Rock smashes Scissors!'
    else 'Scissors cut Paper!'
    end
  end

  def declare_winner
    if winner == 'Player'
      puts display_message(player)
      puts "\nPlayer wins!"
    elsif winner == 'Computer'
      puts display_message(computer)
      puts "\nComputer wins."
    else
      puts "\nIt's a tie."
    end
  end

  def play_again?
    puts "\nHow about another round? <n to quit>"
    reply = gets.chomp.downcase
    play unless reply == 'n'
    puts "\nThank you for playing Rock, Paper, and Scissors!"
    exit
  end

  def play
    choose_hands
    display_hands
    compare_hands
    declare_winner
    sleep 1
    play_again?
  end
end

game = Game.new.play
