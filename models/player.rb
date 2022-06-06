# frozen_string_literal: true

class Player
  attr_accessor :name, :bank, :hand

  def initialize(name)
    @name = name
    @bank = 0
    @hand = []
  end

  def make_bet(value)
    @bank -= value
    value
  end

  def current_score
    @sum = 0
    @hand.each { |c| @sum += c.score(@sum) }
    @sum
  end

  def ace?
    !!@hand.detect { |c| c.value == 'A' }
  end

  def show_face
    @hand.map(&:to_s).join(' ')
  end

  def show_back
    @hand.map { "\u2592" }.join(' ')
  end
end
