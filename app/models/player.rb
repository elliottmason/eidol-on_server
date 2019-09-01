class Player < ApplicationRecord
  has_many :player_combatants

  # @param args [Hash]
  # @return [Player]
  def create(*args)
  end
end
