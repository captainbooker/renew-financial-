# frozen_string_literal: true

module WarGame
  class Deck
    include Enumerable

    def self.standard(shuffle: true)
      new(Card::RANKS.flat_map { |r| 4.times.map { Card.new(r) } }, shuffle:)
    end

    def initialize(cards, shuffle: true)
      @cards = shuffle ? cards.shuffle : cards.dup
    end

    def size   = @cards.size
    def empty? = @cards.empty?
    def draw(n = 1) = @cards.shift(n)
    def push(*cards) = @cards.push(*cards)
    def each(&) = @cards.each(&)
  end
end
