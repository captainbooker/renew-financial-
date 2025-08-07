# frozen_string_literal: true

module WarGame
  class Card
    RANKS  = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze
    VALUES = RANKS.each_with_index.to_h { |r, i| [ r, i + 2 ] }.freeze # 2..14

    attr_reader :rank, :value
    def initialize(rank)
      @rank  = rank
      @value = VALUES.fetch(rank) { raise ArgumentError, "Bad rank: #{rank}" }
    end

    include Comparable
    def <=>(other) = value <=> other.value
    def to_s       = rank
  end
end
