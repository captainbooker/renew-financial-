# frozen_string_literal: true
module WarGame
  class Game
    attr_reader :players, :rounds_played

    def initialize(player_names)
      raise ArgumentError, "2–4 players supported" unless (2..4).cover?(player_names.size)

      full_deck = Deck.standard
      hand      = full_deck.size / player_names.size
      @players  = player_names.map do |name|
        Player.new(name, Deck.new(full_deck.draw(hand), shuffle: false))
      end
      @rounds_played = 0
    end

    # Plays until one player owns all 52 cards or round_cap reached.
    # Returns the winning Player instance or nil.
    def play(verbose: false, round_cap: 10_000)
      until (win = winner?) || @rounds_played >= round_cap
        play_round(verbose:)
        eliminate_empty_players
      end
      win
    end

    private

    def play_round(verbose: false)
      active = players.reject(&:out_of_cards?)
      winner_idx, pot = RoundResolver.play(active)

      if winner_idx
        active[winner_idx].collect(pot.shuffle) # mild shuffle prevents loops
        log_round(active[winner_idx], pot, verbose)
      end

      @rounds_played += 1
    end

    def eliminate_empty_players
      players.reject!(&:out_of_cards?)          # always prune empty decks
    end

    def winner?
      active = players.reject(&:out_of_cards?)
      active.one? ? active.first : nil
    end

    def log_round(winner, pot, verbose)
      return unless verbose
      puts "Round #{@rounds_played + 1}: #{winner.name} wins #{pot.size} cards "\
           "(total #{winner.deck.size})"
    end
  end
end
