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
    return @hand.sum(&:score) unless ace?

    aces_count = @hand.count { |c| c.value == 'A' }
    score = @hand.reject { |c| c.value == 'A' }.sum(&:score)
    aces_count.times { score += score < 11 ? 11 : 1 }
    score
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
