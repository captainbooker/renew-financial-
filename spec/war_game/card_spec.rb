# frozen_string_literal: true
RSpec.describe WarGame::Card do
  it "orders ranks correctly" do
    expect(described_class.new("A")).to be > described_class.new("K")
    expect(described_class.new("10")).to be < described_class.new("J")
  end
end
