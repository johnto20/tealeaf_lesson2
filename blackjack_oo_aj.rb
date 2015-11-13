

class Card
  attr_accessor :suit, :face_value

  def initialize(s, fv)
    @suit = s 
    @face_value = fv 
  end

  def pretty_output
    "The #{face_value} of #{find_suit}"
  end

  def to_s
    pretty_output
  end

  def find_suit
    ret_val = case suit
      when "H" then "Hearts"
      when "D" then "Diamonds"
      when "S" then "Spades"
      when "C" then "Clubs"
    end
    ret_val    
  end
end

class Deck
  attr_accessor :cards 
  
  def initialize
    @cards = []
    ['H','D','S','C'].each do |suit|
      ['2','3','4','5','6','7','8','9','10','J','Q','K','A'].each do |face_value|
        @cards << Card.new(suit, face_value)
      end
    end 
    scramble! 
  end

  def scramble!
    cards.shuffle!
  end

  def deal_one
    cards.pop
  end
end

module Hand 
  def show_hand
    puts "------#{name}'s hand ----"
    cards.each do |card|
      puts "=> #{card}"
    end
    puts "=> Total: #{total}"
  end

  def total
    face_values = cards.map{|card| card.face_value}

    total = 0
    face_values.each do |val|
      if val == "A"
        total += 11
      else
        total += (val.to_i == 0 ? 10 : val.to_i)
      end
   end

  face_values.select{|val| val == "A"}.count.times do
    break if total <= 21
    total -= 10
  end
  
  total
end

  def add_card(new_card)
    cards << new_card
  end

  def check_blackjack
    if total == 21 then puts "Blackjack!"
    else
      puts ""
    end
  end

end

class Player
  include Hand

  attr_accessor :name, :cards

  def initialize(n)
    @name = n
    @cards = []   
  end
end

class Dealer
  include Hand

  attr_accessor :name, :cards

  def initialize
    @name = "Dealer"
    @cards = []
  end
end




class Game
  include Hand
    
    attr_accessor :deck, :player, :dealer

  def initialize
    @deck = Deck.new
    @player = Player.new("Andrew")
    @dealer = Dealer.new
  end

  def deal_initial_cards
    player.add_card(deck.deal_one)
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
  end
    
  

  

  def run
    deal_initial_cards
    player.show_hand
    player.check_blackjack

    while player.total < 21
      puts "What would you like to do? 1)for hit, 2) for stay"
      hit_or_stay = gets.chomp

      if !['1', '2'].include?(hit_or_stay)
        puts "Error, you must enter 1 or 2"
      next
      end

      if hit_or_stay == '2'
      puts "You chose to stay"
      break
      end

  
    player.add_card(deck.deal_one)
    puts "Player has been dealt #{player.cards.last}"
    player.show_hand
  
    if player.total == 21
      puts "Congratulations, you hit blackjack, YOU WIN"
      exit
    elsif player.total > 21
      puts "Sorry, it looks like you busted"
      exit
    end
  end

    dealer.show_hand
    dealer.check_blackjack

    if dealer.total == 21
      puts "Sorry, dealer hits blackjack, YOU LOSE."
      exit
    end

    while dealer.total < 17
      dealer.add_card(deck.deal_one)
      puts "Dealing new card for dealer: #{dealer.cards.last}"
      dealer.show_hand
    if dealer.total == 21
      puts "Sorry dealer hit jackblack. You lose."
      exit
    elsif dealer.total > 21
      puts "Congratulation, dealer busted.  YOU WIN!"
      exit
    end
  end



  if dealer.total > player.total
      puts "Sorry, dealer won"
    elsif dealer.total < player.total
      puts "Congratulations, you win"
  else
    puts "It's a tie"
  end
end
end




game = Game.new
game.run


