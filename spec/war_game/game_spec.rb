# frozen_string_literal: true

RSpec.describe WarGame::Game do
  it "produces a winner within a reasonable round cap" do
    game   = described_class.new(%w[Alice Bob])
    winner = game.play(round_cap: 5_000)
    expect(winner).to be_a(WarGame::Player)
    expect(winner.deck.size).to eq 52
  end

  it "handles multi-player elimination" do
    game   = described_class.new(%w[Alice Bob Carol Dave])
    winner = game.play(round_cap: 10_000)
    expect(winner).to be_a(WarGame::Player)
    expect(game.players.size).to eq 1
  end

  it "resolves a war correctly" do
    c  = WarGame::Card
    p1 = WarGame::Player.new("P1", WarGame::Deck.new([ c.new("A") ] * 26, shuffle: false))
    p2 = WarGame::Player.new("P2", WarGame::Deck.new([ c.new("A") ] * 26, shuffle: false))
    idx, pot = WarGame::RoundResolver.play([ p1, p2 ])
    expect(idx).not_to be_nil
    expect(pot.size).to be >= 2
  end
end
