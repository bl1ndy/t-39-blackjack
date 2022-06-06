# frozen_string_literal: true

require_relative '../models/deck'
require_relative '../models/player'

# rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/ClassLength
class Interface
  HAND_MAX_CARDS = 3
  HAND_MAX_SCORE = 21
  DEALER_LIMIT = 17
  MAX_ROUNDS = 2

  def call
    print "Welcome to the Game! What's your name, sir? : "

    name = gets.chomp
    name = 'Player' if name.empty?

    @player = Player.new name
    @dealer = Player.new 'Dealer'
    @player.bank = 100
    @dealer.bank = 100

    loop do
      check_banks

      @deck = Deck.new
      @player.hand = []
      @dealer.hand = []
      @bank = 0

      clear_screen
      puts 'Dealing...'
      sleep 1

      2.times { @player.hand << @deck.deal_card }
      2.times { @dealer.hand << @deck.deal_card }

      @bank += @player.make_bet(10)
      @bank += @dealer.make_bet(10)

      round

      showdown

      puts "Want to play one more time, #{name}?"
      puts '1: Yes'
      puts '2: Exit'

      input = gets.chomp.to_i

      exit if input == 2
    end
  end

  private

  def clear_screen
    system 'clear'
  end

  def round
    @rounds = 1

    loop do
      break if @player.hand.count == HAND_MAX_CARDS || @rounds >= MAX_ROUNDS

      clear_screen
      puts "Dealer cards: #{@dealer.show_back}"
      puts "Your cards: #{@player.show_face} >> #{@player.current_score} points"
      puts "Current pot: #{@bank}"
      puts "Your bank: #{@player.bank}"
      puts "\n"
      puts "What you're gonna do?"
      puts "\n"
      puts '1: Take card'
      puts '2: Check'
      puts '3: Showdown'

      input = gets.chomp.to_i

      case input
      when 1
        @player.hand << @deck.deal_card
        break if @player.current_score > HAND_MAX_SCORE

        @rounds += 1
        dealer_turn
      when 2
        @rounds += 1
        dealer_turn
      else
        break
      end
    end
  end

  def dealer_turn
    if @dealer.current_score >= DEALER_LIMIT || @player.current_score > HAND_MAX_SCORE
      puts 'Dealer checks...'
      sleep 2
      return
    end

    return unless @dealer.hand.count < HAND_MAX_CARDS

    @dealer.hand << @deck.deal_card
    puts 'Dealer takes card...'
    sleep 2
  end

  def winner
    p1 = HAND_MAX_SCORE - @player.current_score
    p2 = HAND_MAX_SCORE - @dealer.current_score

    return if (p1 == p2) || (p1.negative? && p2.negative?)
    return @player if p2.negative?
    return @dealer if p1.negative?
    return @player if @player.current_score > @dealer.current_score

    @dealer
  end

  def showdown
    clear_screen
    puts "Dealer cards: #{@dealer.show_face} >> #{@dealer.current_score} points"
    puts "Your cards: #{@player.show_face} >> #{@player.current_score} points"

    if winner
      winner.bank += @bank
      puts "#{winner.name} wins!" if winner
    else
      @player.bank += @bank / 2
      @dealer.bank += @bank / 2
      puts 'Draw!'
    end

    puts "\n"
  end

  def check_banks
    return unless @player.bank.zero? || @dealer.bank.zero?

    puts "Players haven't enough money"
    exit
  end
end
# rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/ClassLength
