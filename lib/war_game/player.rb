# frozen_string_literal: true

module WarGame
  class Player
    attr_reader :name, :deck
    def initialize(name, deck)
      @name, @deck = name, deck
    end

    def out_of_cards? = deck.empty?
    def play_card     = deck.draw.first
    def collect(cards) = deck.push(*cards)
  end
end
