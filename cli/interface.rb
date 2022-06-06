# frozen_string_literal: true

require_relative '../models/deck'
require_relative '../models/player'

# rubocop:disable Metrics/MethodLength, Metrics/AbcSize
class Interface
  def call
    print "Welcome to the Game! What's your name, sir? : "

    name = gets.chomp
    name = 'Player' if name.empty?

    @player1 = Player.new name
    @player2 = Player.new 'Dealer'
    @player1.bank = 100
    @player2.bank = 100

    loop do
      check_banks

      @deck = Deck.new
      @player1.hand = []
      @player2.hand = []
      @bank = 0

      clear_screen
      puts 'Dealing...'
      sleep 1

      2.times { @player1.hand << @deck.deal_card }
      2.times { @player2.hand << @deck.deal_card }

      @bank += @player1.make_bet(10)
      @bank += @player2.make_bet(10)

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
    loop do
      break if @player1.hand.count == 3

      clear_screen
      puts "Dealer cards: #{@player2.show_back}"
      puts "Your cards: #{@player1.show_face} >> #{@player1.current_score} points"
      puts "Current pot: #{@bank}"
      puts "Your bank: #{@player1.bank}"
      puts "\n"
      puts "What you're gonna do?"
      puts "\n"
      puts '1: Take card'
      puts '2: Check'
      puts '3: Showdown'

      input = gets.chomp.to_i

      case input
      when 1
        @player1.hand << @deck.deal_card
        break if @player1.current_score > 21

        dealer_turn
      when 2
        dealer_turn
      else
        dealer_turn
        break
      end
    end
  end

  def dealer_turn
    if @player2.current_score >= 17 || @player1.current_score > 21
      puts 'Dealer checks...'
      sleep 2
      return
    end

    return unless @player2.hand.count < 3

    @player2.hand << @deck.deal_card
    puts 'Dealer takes card...'
    sleep 2
  end

  def winner
    p1 = 21 - @player1.current_score
    p2 = 21 - @player2.current_score

    return if (p1 == p2) || (p1.negative? && p2.negative?)
    return @player1 if p2.negative?
    return @player2 if p1.negative?
    return @player1 if @player1.current_score > @player2.current_score

    @player2
  end

  def showdown
    clear_screen
    puts "Dealer cards: #{@player2.show_face} >> #{@player2.current_score} points"
    puts "Your cards: #{@player1.show_face} >> #{@player1.current_score} points"

    if winner
      winner.bank += @bank
      puts "#{winner.name} wins!" if winner
    else
      @player1.bank += @bank / 2
      @player2.bank += @bank / 2
      puts 'Draw!'
    end

    puts "\n"
  end

  def check_banks
    return unless @player1.bank.zero? || @player2.bank.zero?

    puts "Players haven't enough money"
    exit
  end
end
# rubocop:enable Metrics/MethodLength, Metrics/AbcSize
