# frozen_string_literal: true

require_relative 'deck'

class Card
  attr_reader :value, :suit

  MAX_ACE = 11
  MIN_ACE = 1
  PICTURED_VALUE = 10
  HAND_MAX = 21

  def initialize(value, suit)
    @value = value
    @suit = suit
  end

  def score(hand_score = nil)
    return @value.to_i if Deck::CARD_VALUES[:numbered].include?(@value)
    return PICTURED_VALUE if Deck::CARD_VALUES[:pictured].include?(@value)

    hand_score + MAX_ACE > HAND_MAX ? MIN_ACE : MAX_ACE
  end

  def to_s
    "#{@value}#{Deck::SUITS[@suit]}"
  end
end
