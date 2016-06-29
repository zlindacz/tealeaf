# Linda Zhang
# Email: zlindacz@gmail.com
# Github: https://github.com/zlindacz/lesson_1.git

# Object-Oriented Blackjack

class Deck
  attr_accessor :shoe

  VALUES = %w(2 3 4 5 6 7 8 9 10 J Q K A)
  SUITS = %w(Hearts Diamonds Spades Clubs)

  def initialize
    @shoe = []
    VALUES.each do |value|
      SUITS.each do |suit|
        @shoe << Card.new(value, suit)
      end
    end
    @shoe = (@shoe * 6).shuffle
  end

  def give_card
    shoe.pop
  end

  def refill
    initialize if shoe.size < 51
  end
end

class Card
  attr_accessor :value, :suit

  def initialize(value, suit)
    @value = value
    @suit = suit
  end

  def to_s
    "#{value} of #{suit}"
  end

  def display_suit
    case suit
    when 'Hearts'
      "\xE2\x99\xA5"
    when 'Diamonds'
      "\xE2\x99\xA6"
    when 'Spades'
      "\xE2\x99\xA0"
    else
      "\xE2\x99\xA3"
    end
  end
end
  
module Hand

  BORDER = '+------+'
  BACK = '|~~~~~~|'
  FRONT = '|      |'
  SPACE = '  '
  BLACKJACK = 21
  ACE_HIGH = 11
  ACE_LOW = 1
  DEALER_MIN = 17
  FACE_CARD = 10

  def show_one_card
    puts "+-+-+-+-+ #{name}'s HAND +-+-+-+-+\n\n"
    print BORDER, SPACE, BORDER, "\n"
    if cards[1].value == '10'
      print BACK, SPACE, "| #{cards[1].value}   |", "\n"
    else
      print BACK, SPACE, "| #{cards[1].value}    |", "\n"
    end
    print BACK, SPACE, FRONT, "\n"
    print BACK, SPACE, "|   #{(cards[1].display_suit)}  |", "\n"
    print BACK, SPACE, FRONT, "\n"
    print BORDER, SPACE, BORDER, "\n"
    puts "#{cards[1]}"
    puts
  end

  def show_hand
    puts "+-+-+-+-+ #{name}'s HAND +-+-+-+-+\n\n"
    number_of_cards = cards.length
    number_of_cards.times { print BORDER, SPACE }
    puts 
    cards.each_with_index do |_, idx|
      if cards[idx].value == '10'
        print "| #{cards[idx].value}   |", SPACE
      else
        print "| #{cards[idx].value}    |", SPACE
      end
    end
    puts 
    number_of_cards.times { print FRONT, SPACE }
    puts 
    cards.each_with_index do |_, idx|
      print "|   #{cards[idx].display_suit}  |", SPACE
    end
    puts 
    number_of_cards.times { print FRONT, SPACE }
    puts
    number_of_cards.times { print BORDER, SPACE }
    puts
    cards.each { |card| puts "#{card}"}
    puts
    puts "Total: #{total}"
    puts
  end

  def total
    total = 0
    cards.each do |card|
      if card.value == 'A'
        total += ACE_HIGH
      elsif card.value.to_i == 0
        total += FACE_CARD
      else
        total += card.value.to_i
      end
    end
    cards.each { |card| total -= (ACE_HIGH - ACE_LOW) if total > BLACKJACK && card.value == 'A'}
    total
  end

  def bust?
    total > BLACKJACK
  end

  def blackjack?
    cards.size == 2 && total == BLACKJACK
  end
end

class Player

  include Hand

  attr_accessor :name, :cards, :outcome, :chips, :wager

  def initialize
    @name = ask_name
    @cards = []
    @chips = 100
    system 'clear'
    sleep 0.5
    puts "\n＼(￣▽￣)／  #{@name}, here are 100 chips to get you started.\n\n"
  end

  def ask_name
    puts "\nWhat is your name?\n\n"
    self.name = gets.chomp.capitalize
    while /\W|\d/.match(self.name)
      puts "\nヾ( ￣O￣)ツ  Please type letters.\n\n"
      self.name = gets.chomp.capitalize
    end
    self.name
  end

  def chips_wagered
    sleep 1
    puts "\n<(￣︶￣)>  How much would you like to bet? [1-#{chips}]\n\n"
    self.wager = gets.chomp.to_i
    until (1..chips).include?(self.wager)
      puts "\nヾ( ￣O￣)ツ  Invalid entry; you must bet an amount between 1 and #{chips}.\n\n"
      self.wager = gets.chomp.to_i
    end
    self.chips -= wager
    wager
  end

  def broke?
    chips < 1
  end
end

class Dealer
  
  include Hand

  attr_accessor :name, :cards, :outcome

  def initialize
    @name = 'Dealer'
    @cards = []
  end

  def soft_seventeen?
    to_add = 0
    if total == Hand::DEALER_MIN
      cards.each do |card|
        value = card.value
        if value.to_i == 0
          to_add += FACE_CARD
        else
          to_add += value.to_i
        end
      end
      to_add < Hand::DEALER_MIN
    else
      false
    end
  end
end

class Game

  attr_accessor :player, :dealer, :deck, :winner

  def initialize
    system 'clear'
    puts "\n(￣▽￣)ノ  Hello and welcome to Blackjack!"
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def pause
    sleep 1
  end

  def place_bet
    player.chips_wagered
  end

  def deal
    2.times do
      hit(player)
      hit(dealer)
    end
  end

  def hit_or_stand
    pause
    puts "\n#{player.name}, what's your next move? 1) Hit, 2) Stand\n"
    answer = gets.chomp.to_i
    until [1, 2].include?(answer)
      puts "\nヾ( ￣O￣)ツ  Not a valid selection; please try again. 1) Hit, 2) Stand\n"
      answer = gets.chomp.to_i
    end
    answer
  end

  def hit(whose_turn)
    whose_turn.cards << deck.give_card
  end

  def initial_reveal
    system 'clear'
    dealer.show_one_card
    player.show_hand
  end

  def show_hands
    system 'clear'
    dealer.show_hand
    player.show_hand
  end

  def player_turn
    if player.blackjack?
      pause
      puts "＼(￣▽￣)／  BLACKJACK for #{player.name}!\n\n"
      player.outcome = :blackjack
    elsif player.bust?
      pause
      puts "(￣ヘ￣)  #{player.name} BUST!\n\n"
      player.outcome = :bust
    elsif hit_or_stand == 1
      hit(player)
      initial_reveal
      player_turn
    else
      player.outcome = :standing
    end
    pause
  end

  def dealer_turn
    show_hands
    if dealer.blackjack?
      pause
      puts "＼(￣▽￣)／  BLACKJACK for #{dealer.name}!\n\n"
      dealer.outcome = :blackjack
    elsif player.outcome == :bust || dealer.total >= Hand::DEALER_MIN && !dealer.soft_seventeen? && !dealer.bust?
      dealer.outcome = :standing
    elsif dealer.bust?
      pause
      puts "(￣ヘ￣)  #{dealer.name} BUST!\n\n"
      dealer.outcome = :bust
    else
      pause
      hit(dealer)
      dealer_turn
    end
  end

  def compare
    if player.outcome == :blackjack && dealer.outcome == :blackjack ||
      player.total == dealer.total && dealer.outcome != :blackjack && player.outcome != :blackjack
      self.winner = :tie
    elsif player.outcome == :blackjack && dealer.outcome != :blackjack || 
      player.outcome != :bust && dealer.outcome == :bust ||
      player.outcome == :standing && dealer.outcome == :standing && player.total > dealer.total
      self.winner = player.name
    else
      self.winner = dealer.name
    end
  end

  def declare_winner
    pause
    if winner == :tie
      puts "(~˘▾˘)~  It's a tie.\n\n"
    else
      puts "ヽ(*^〇^)ﾉ  The winner is: #{winner}\n\n"
    end
    pause
  end

  def distribute_winnings
    if winner == player.name && player.outcome == :blackjack
      player.chips += player.wager * 2.5
    elsif winner == player.name
      player.chips += player.wager * 2
    elsif winner == :tie
      player.chips += player.wager
    end
    pause
    puts "(￣▽￣)ノ  #{player.name} now has #{player.chips} chips.\n\n"
    pause
  end

  def play_again?
    if player.broke?
      puts "(￣ヘ￣)  Whoops, you lost all your chips. Game Over!"
      pause
      pause
      goodbye
    else
      puts '<(￣︶￣)> Another round? [n to quit]'
      answer = gets.chomp.downcase
      answer == 'n' ? goodbye : reset
    end
  end

  def reset
    player.cards = []
    dealer.cards = []
    deck.refill
    play
  end

  def goodbye
    system 'clear'
    puts "\n(￣▽￣)ノ  #{player.name}, thank you for playing Blackjack!\n\n"
    pause
    puts "You walk away with #{player.chips} chips.\n\n"
    pause
    exit
  end

  def play
    place_bet
    deal
    initial_reveal
    player_turn
    dealer_turn
    compare
    declare_winner
    distribute_winnings
    play_again?
  end
end

Game.new.play