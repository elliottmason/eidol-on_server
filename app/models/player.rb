class Player < ApplicationRecord
  has_many :combatants_players

  # @param args [Hash]
  # @return [Player]
  def create(*args)
  end
end
