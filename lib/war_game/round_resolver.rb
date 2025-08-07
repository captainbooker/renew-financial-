# frozen_string_literal: true
module WarGame
  # Resolves one complete round (including wars) and returns:
  #   [index_of_winner_in_original_player_array, pot_of_cards]
  class RoundResolver
    def self.play(players_in_round)
      pot        = []
      contenders = players_in_round.dup
      war        = false

      loop do
        face_ups = []

        contenders.each do |pl|
          if war
            # Leaders must place up to three face-down cards.
            needed_for_face_up = [pl.deck.size - 1, 0].max
            face_down_count    = [3, needed_for_face_up].min
            pot.concat(pl.deck.draw(face_down_count))
          end

          card = pl.play_card     # may return nil (exhausted)
          next unless card

          pot << card
          face_ups << [pl, card]
        end

        # Should not happen: all exhausted simultaneously
        return [nil, pot] if face_ups.empty?

        high_val = face_ups.map { |_, c| c.value }.max
        leaders  = face_ups.select { |_, c| c.value == high_val }.map(&:first)

        # Winner found
        return [players_in_round.index(leaders.first), pot] if leaders.one?

        # All leaders are empty after the flip – pick deterministic winner
        if leaders.all? { |pl| pl.deck.empty? }
          return [players_in_round.index(leaders.first), pot]
        end

        # WAR continues
        contenders = leaders
        war        = true
      end
    end
  end
end
