# frozen_string_literal: true

require_relative 'deck'

class Card
  attr_reader :value, :suit

  def initialize(value, suit)
    @value = value
    @suit = suit
  end

  def score
    return 11 if @value == 'A'

    @score = Deck::CARD_VALUES[:numbered].include?(@value) ? @value.to_i : 10
  end

  def to_s
    "#{@value}#{Deck::SUITS[@suit]}"
  end
end
