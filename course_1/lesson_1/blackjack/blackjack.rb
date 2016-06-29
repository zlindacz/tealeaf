# Simple Blackjack

# Helper methods

BORDER = '+------+'
BACK = '|~~~~~~|'
FRONT = '|      |'
SPACE = '  '


def say(msg)
  puts "+-+-+-+-+ #{msg} +-+-+-+-+".center(80)
  puts
  sleep 1
end

def display_suit(card)
  suit = case card
    when 'Hearts'
      "\xE2\x99\xA5"
    when 'Diamonds'
      "\xE2\x99\xA6"
    when 'Spades'
      "\xE2\x99\xA0"
    else
      "\xE2\x99\xA3"
    end
  return suit
end

def display_dealer_first(hand)
  print BORDER, SPACE, BORDER, "\n"
  if hand.last[0] == '10'
    print BACK, SPACE, "| #{hand.last[0]}   |", "\n"
  else
    print BACK, SPACE, "| #{hand.last[0]}    |", "\n"
  end
  print BACK, SPACE, FRONT, "\n"
  print BACK, SPACE, "|   #{display_suit(hand.last[1])}  |", "\n"
  print BACK, SPACE, FRONT, "\n"
  print BORDER, SPACE, BORDER, "\n"
end

def display(hand)
  number_of_cards = hand.length
  number_of_cards.times { print BORDER, SPACE }
  puts
  hand.each_with_index do |_, idx|
    if hand[idx][0] == '10'
      print "| #{hand[idx][0]}   |", SPACE
    else
      print "| #{hand[idx][0]}    |", SPACE
    end
  end
  puts
  number_of_cards.times { print FRONT, SPACE }
  puts
  hand.each_with_index do |_, idx|
    print "|   #{display_suit(hand[idx][1])}  |", SPACE
  end
  puts
  number_of_cards.times { print FRONT, SPACE }
  puts
  number_of_cards.times { print BORDER, SPACE }
  puts
end

def total_of(hand)
  aces = 0
  total = 0
  card_values = hand.map { |card| card[0] }
  card_values.each do |value|   # ['2', 'A']
    if value == 'A'
      aces += 1
      total += 11
    elsif value.to_i == 0   # J, Q, K
      total += 10
    else
      total += value.to_i
    end
  end
  while total > 21 && aces > 0
    aces -= 1
    total -= 10
  end
  total
end

def hit_or_stand?(hand)
  say 'Would you like to hit or stand? [h/s]'
  answer = gets.chomp.downcase
  until ['h', 's'].include?(answer)
    say 'Please select h to hit or s to stand.'
    answer = gets.chomp.downcase
  end
  answer
end

def busted?(hand)
  total_of(hand) > 21
end

def blackjack?(hand)
  total_of(hand)  == 21
end

def soft?(hand)   # [["6", "Hearts"], ["A", "Clubs"]]
  card_values = hand.map { |card| card[0] }
  to_add = card_values.map do |value|
    if value == 'A' || value.to_i == 0
      value = '10'
    else
      value
    end
  end
  to_add.inject { |result, number| result.to_i + number.to_i } < 17
end

# Methods for game-play

def initialize_deck
  raw_deck = []
  deck = []
  suits = %w(Hearts Diamonds Spades Clubs)
  cards = %w(2 3 4 5 6 7 8 9 10 J Q K A)
  6.times { raw_deck << cards.product(suits) }
  raw_deck.flatten!.each_slice(2) { |card| deck << card}
  deck.shuffle!
end

def give_card!(hand, deck)
  hand << deck.shift
end

def reveal_dealer(hand)
  say "DEALER has #{hand.last[0]} of #{hand.last[1]}"
end

def reveal_player(name, hand)
  say "#{name} has #{hand.first[0]} of #{hand.first[1]} and #{hand.last[0]} of #{hand.last[1]}, for a total of #{total_of(hand)}"
end

def player_turn(hand, deck, outcome, name)
  if blackjack?(hand)
    say "You have BLACKJACK!!"
    return outcome["#{name}"] = 22
  end

  while hit_or_stand?(hand) == 'h'
    give_card!(hand, deck)
    display(hand)
    say "Your new card is #{hand.last[0]} of #{hand.last[1]}, for a total of #{total_of(hand)}."
    if busted?(hand)
      say "Uh-oh, you've busted!"
      return outcome["#{name}"] = 0 # if player busts, dealer wins
    end
  end
  outcome["#{name}"] = total_of(hand)
end

def dealer_turn(hand, deck, outcome)  # [["6", "Hearts"], ["A", "Clubs"]]
  display(hand)
  say "The dealer's hole card is #{hand.first[0]} of #{hand.first[1]}, for a total of #{total_of(hand)}."
  if blackjack?(hand)
    say "The DEALER has BLACKJACK."
    return outcome['DEALER'] = 22
  end

  while total_of(hand) < 17 || (total_of(hand) == 17 && soft?(hand))
    give_card!(hand, deck)
    display(hand)
    say "The DEALER's new card is #{hand.last[0]} of #{hand.last[1]}, for a total of #{total_of(hand)}."
    if busted?(hand)   # lowest sum cannot be 1, but dealer bust still wins over player bust
      say 'Whoops, the DEALER has busted!'
      return outcome['DEALER'] = 1
    end
  end
  outcome['DEALER'] = total_of(hand)
end

def announce_winner(outcome, name, wager)
  if outcome["#{name}"] > outcome['DEALER']
    say "#{name} WINS!"
  elsif outcome["#{name}"] < outcome['DEALER']
    say 'DEALER WINS.'
  else
    say "IT'S A TIE."
  end
end

def calculate_winnings(outcome, name, chips, wager)
  if outcome["#{name}"] > outcome['DEALER']
    if outcome["#{name}"] == 22
      chips += wager * 2.5
    else
      chips += wager * 2
    end
  elsif outcome["#{name}"] == outcome['DEALER']
    chips += wager
  end
  return chips
end

# Game begins

system 'clear'
say 'Welcome to Blackjack! What is your name?'
player_name = gets.chomp.upcase
if player_name == ''
  player_name = %w(Brando Quinlivan Pandora Godzilla Sockatoo).sample.upcase
  say "You're secretive; then your alias is #{player_name}."
end
say "Hello #{player_name}, let's begin."
say "You start with 100 chips."
game_chips = 100

play_again = 'y'

while play_again != 'n'

  say "How much would you like to wager?"
  wager = gets.chomp.to_i
  until (1..game_chips).include?(wager)
    say "Please wager an amount between 1 and #{game_chips}."
    wager = gets.chomp.to_i
  end
  game_chips -= wager

  dealer_hand = []
  player_hand = []
  game_outcome = {}

  game_deck = initialize_deck
  2.times do
    give_card!(dealer_hand, game_deck)
    give_card!(player_hand, game_deck)
  end

  display_dealer_first(dealer_hand)
  reveal_dealer(dealer_hand)
  display(player_hand)
  reveal_player(player_name, player_hand)

  player_turn(player_hand, game_deck, game_outcome, player_name)
  dealer_turn(dealer_hand, game_deck, game_outcome)
  announce_winner(game_outcome, player_name, wager)
  game_chips = calculate_winnings(game_outcome, player_name, game_chips, wager)

  say "You now have #{game_chips} chips."

  if game_chips == 0
    say "You're all out of chips. Here is another 100."
    game_chips = 100
  end

  say 'Would you like to play again? [y/n]'
  play_again = gets.chomp.downcase
end

system 'clear'
say "Thank you for playing BLACKJACK!"
say "You walk away with #{game_chips} in winnings!"
