require 'rubygems'
require 'sinatra'

use Rack::Session::Cookie, :key => 'rack.session', :path => '/', :secret => 'blackjack_2'

BLACKJACK = 21
ACE_HIGH = 11
ACE_LOW = 1
DEALER_MIN = 17
FACE_CARD = 10
STARTING_CHIPS = 100

SUITS = %w(hearts diamonds clubs spades)
VALUES = %w(2 3 4 5 6 7 8 9 10 J Q K A)

helpers do
  def new_deck
    session[:deck] = VALUES.product(SUITS).shuffle!
  end

  def deal
    2.times do
      session[:dealer_hand] << session[:deck].pop
      session[:player_hand] << session[:deck].pop
    end
  end

  def hit(hand)
    hand << session[:deck].pop
  end

  def total(hand)
    total = 0
    hand.each do |card|
      value = card[0]
      if value == 'A'
        total += ACE_HIGH
      else
        total += value.to_i == 0 ? FACE_CARD : value.to_i
      end
    end
      # correct for aces
    if total > BLACKJACK
      hand.select { |card| card[0] == 'A' }.count.times do
        break if total <= BLACKJACK
        total -= FACE_CARD
      end
    end
    total
  end

  def display(card) # card = ['K', 'diamonds']
    value = card[0]
    suit = card[1]
    if %w(J Q K A).include?(value)
      value = case value
        when 'J' then 'jack'
        when 'Q' then 'queen'
        when 'K' then 'king'
        when 'A' then 'ace'
      end
    end

    "<img src= '/images/cards/#{suit}_#{value}.jpg' class='card_image' />"
  end

  def soft?(hand)
    to_add = 0
    if total(hand) == DEALER_MIN
      hand.each do |card|
        value = card[0]
        to_add += value.to_i == 0 ? FACE_CARD : value.to_i
      end
      to_add < DEALER_MIN
    else
      false
    end
  end

  def blackjack?(hand)
    hand.size == 2 && total(hand) == BLACKJACK
  end

  def bust?(hand)
    total(hand) > BLACKJACK
  end

  def broke?
    session[:chips] < 1
  end

  def reset_player_name!
    session.delete(:player_name)
  end

  def decide_winner
    dealer_outcome = session[:dealer_outcome]
    player_outcome = session[:player_outcome]
    dealer_total = total(session[:dealer_hand])
    player_total = total(session[:player_hand])
    if player_outcome == "Blackjack" && dealer_outcome == "Blackjack" ||
      player_total == dealer_total && player_outcome == "Standing" && dealer_outcome == "Standing"
      session[:winner] = "Tie"
    elsif player_outcome == "Blackjack" && dealer_outcome != "Blackjack" || 
      player_outcome != "Bust" && dealer_outcome == "Bust" ||
      player_outcome == "Standing" && dealer_outcome == "Standing" && player_total > dealer_total
      session[:winner] = session[:player_name]
    else
      session[:winner] = "Dealer"
    end
  end

  def final_message
    if session[:winner] == session[:player_name]
      if session[:player_outcome] == "Blackjack"
        @win_msg = "Congratulations! <strong>#{session[:player_name]}</strong> wins with Blackjack!"
      else
        @win_msg = "Congratulations! <strong>#{session[:player_name]}</strong> wins with #{total(session[:player_hand])} vs Dealer's #{total(session[:dealer_hand])}!"
      end
    elsif session[:winner] == "Dealer"
      if session[:dealer_outcome] == "Blackjack" && session[:player_outcome] != "Blackjack"
        @lose_msg = "Oi, <strong>Dealer</strong> wins with Blackjack."
      else
        @lose_msg = "Bummer, <strong>Dealer</strong> wins with #{total(session[:dealer_hand])} vs #{session[:player_name]}'s #{total(session[:player_hand])}."
      end
    else
      @tie_msg = "Push. It's a <strong>tie</strong>!"
    end
  end
  
  def distribute_winnings
    if session[:winner] == "Tie"
      session[:chips] += session[:wager].to_i
    elsif session[:winner] == session[:player_name]
      if session[:player_outcome] == "Blackjack"
        session[:chips] += session[:wager].to_i * 2.5
      else
        session[:chips] += session[:wager].to_i * 2
      end
    end
  end
end

before do
  @hit_or_stand_btns = true
end

get "/" do
  if session[:player_name]
    erb :bet
  else
    erb :welcome
  end
end

get "/new_game" do  
  erb :welcome
end

post "/new_game" do
  session[:chips] = STARTING_CHIPS
  erb :bet
end

post "/set_name" do
  reset_player_name!
  if params[:player_name].empty?
    @error = "You must enter a name to play."
    halt erb :welcome
  else
    session[:player_name] = params[:player_name].capitalize
    session[:chips] = STARTING_CHIPS
    erb :bet
  end
end

post "/bet" do
  if broke?
    erb :broke
  elsif params[:wager].to_i < 1 || params[:wager].to_i > session[:chips]
    @error = "#{session[:player_name]}, you must enter a number between 1 and #{session[:chips]}."
    halt erb :bet
  else
    session[:wager] = params[:wager].to_i
    session[:chips] -= session[:wager]
    session[:dealer_hand] = []
    session[:player_hand] = []
    session.delete(:player_outcome)
    session.delete(:dealer_outcome)
    new_deck
    deal
    redirect '/game'
  end
end

get "/game" do
  if session[:player_name].nil? || session[:wager].nil?
    redirect "/new_game"
  end
  session[:turn] = session[:player_name]
  if blackjack?(session[:player_hand])
    session[:player_outcome] = "Blackjack"
  end
  erb :game
end

post "/game/player/hit" do
  hit(session[:player_hand])
  if bust?(session[:player_hand])
    session[:player_outcome] = "Bust"
    session[:dealer_outcome] = "Standing"
    session[:turn] = "Dealer"
    redirect "/game/compare"
  else
    erb :game, layout: false
  end
end

post "/game/player/stand" do
  unless session[:player_outcome] == "Blackjack"
    session[:player_outcome] = "Standing"
  end
  redirect "/game/dealer_turn"
end
   
get "/game/dealer_turn" do
  session[:turn] = "Dealer"
  if blackjack?(session[:dealer_hand])
    session[:dealer_outcome] = "Blackjack"
    redirect "/game/compare"
  elsif
    bust?(session[:dealer_hand])
    session[:dealer_outcome] = "Bust"
    redirect "/game/compare"
  elsif total(session[:dealer_hand]) < 17 || soft?(session[:dealer_hand])
    @hit_or_stand_btns = false
    @show_dealer_move_btn = true
    erb :game, layout: false
  else
    session[:dealer_outcome] = "Standing"
    redirect "/game/compare"
  end
end

post "/game/dealer_turn" do
  if blackjack?(session[:dealer_hand])
    session[:dealer_outcome] = "Blackjack"
    redirect "/game/compare"
  elsif bust?(session[:dealer_hand])
    session[:dealer_outcome] = "Bust"
    redirect "/game/compare"
  elsif total(session[:dealer_hand]) < 17 || soft?(session[:dealer_hand])
    hit(session[:dealer_hand])
    redirect "/game/dealer_turn"
  end
end

get "/game/compare" do
  @hit_or_stand_btns = false
  @show_dealer_move_btn = false
  @winner = true
  decide_winner
  final_message
  distribute_winnings
  erb :game, layout: false
end