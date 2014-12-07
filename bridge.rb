### Created by Martin Gwarada ###

module Bridge

  ####### class Card #######

  class Card
    RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A]
    VALUE = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
    SUITS = %w[Spades Hearts Clubs Diamonds]

    attr_accessor :rank, :suit, :value

    def initialize(id)
      self.rank = RANKS[id % 13]
      self.value = VALUE[id % 13]
      self.suit = SUITS[id % 4]
    end
  end

  ####### class Player #######

  class Player
    attr_accessor :playerCards, :tricksWon, :name

    def initialize(name)
      @tricksWon = 0
      $cardArray = (0..51).to_a.shuffle.collect {|id| Card.new(id)}
      @name = name
    end

    def compare
      a = Array.new
      b = Array.new

      if ($hand.empty?)
        play(0)
      else
        playerCards.each do |card|
          if (card.suit == $hand[0].suit && card.value > $hand[0].value)
            a.push(card)
          else
            b.push(card)
          end

        end # do
        if (a == [])
          play(playerCards.index(b[0]))
        else
          play(playerCards.index(a[0]))
        end
      end # outer if
    end # compare method

    def play(index)
      # play will have a method that will pop the card at that index and put it on the $hand array until
      # all 4 players have played and will return the player with the highest card.
      $handHash[self] = playerCards[index]
      $hand.push(playerCards[index])
      puts "#{name} played #{playerCards[index].suit} #{playerCards[index].rank}"
      playerCards.delete_at(index)
    end
  end
  ####### Dealer #########
  class Dealer < Player

    def deal
      s = 0
      while (s < 51)
        $north.push($cardArray.pop)
        $south.push($cardArray.pop)
        $east.push($cardArray.pop)
        $west.push($cardArray.pop)
        s+=4
      end
    end


  end

  ####### class Bridge #######

  class Bridge
    def initialize
      $handHash = Hash.new
      $hand = Array.new
      $north = Array.new
      $south = Array.new
      $east = Array.new
      $west = Array.new
    end
  end
  # class Bridge

  ########## end of class Bridge #######
  game = Bridge.new

  southPlayer = Player.new("South")
  eastPlayer = Player.new("East")
  westPlayer = Player.new("West")
  northPlayer = Dealer.new("North")

  northPlayer.deal

  northPlayer.playerCards = $north
  southPlayer.playerCards = $south
  eastPlayer.playerCards = $east
  westPlayer.playerCards = $west

  puts "Players' original cards"
  puts ""
  puts "North player"
  puts "#{northPlayer.playerCards}"
  puts ""
  puts "South player:"
  puts "#{southPlayer.playerCards}"
  puts ""
  puts "East player:"
  puts "#{eastPlayer.playerCards}"
  puts ""
  puts "West player:"
  puts "#{westPlayer.playerCards}"
  puts ""



  loop  = 0
  while loop < 13 do
    puts ""
    puts "Game #{loop}: "
    northPlayer.compare
    southPlayer.compare
    eastPlayer.compare
    westPlayer.compare


    h = Array.new
    $hand.each {|card| h.push(card.value) if card.suit == $hand[0].suit}

    $handHash.each do |key, value|

      if value.suit == $hand[0].suit

        if value.value == h.max

          key.tricksWon += 1

          puts ""
          puts "#{key.name} player won the trick."
          puts""

          lead = key

        end
      end


    end

    $handHash.clear
    $hand.clear
    loop += 1

  end

  puts ""
  puts "Total tricks won by each individual".upcase
  puts "NorthPlayer: #{northPlayer.tricksWon}"
  puts "SouthPlayer: #{southPlayer.tricksWon}"
  puts "EastPlayer: #{eastPlayer.tricksWon}"
  puts "WestPlayer: #{westPlayer.tricksWon}"

  puts ""
  puts "Players' cards after playing"
  puts ""
  puts "North player:"
  puts northPlayer.playerCards
  puts "South player:"
  puts southPlayer.playerCards
  puts "East player:"
  puts eastPlayer.playerCards
  puts "West player:"
  puts westPlayer.playerCards

end
