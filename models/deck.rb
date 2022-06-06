# frozen_string_literal: true

require_relative 'card'

class Deck
  attr_reader :cards

  CARD_VALUES = {
    numbered: ('2'..'10').to_a,
    pictured: %w[J Q K A]
  }.freeze

  SUITS = {
    clubs: "\u2667", hearts: "\u2661",
    spades: "\u2664", diamonds: "\u2662"
  }.freeze

  def initialize
    @cards = []

    SUITS.each_key do |s|
      CARD_VALUES[:numbered].each { |v| @cards << Card.new(v, s) }
      CARD_VALUES[:pictured].each { |v| @cards << Card.new(v, s) }
    end

    @cards.shuffle!
  end

  def deal_card
    @cards.pop
  end
end
