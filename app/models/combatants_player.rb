# A Player's unique instance of a Combatant with its own progression and stats
class CombatantsPlayer < ApplicationRecord
  belongs_to :combatant
  belongs_to :player
  has_many :combatants_players_moves
  has_many :moves, through: :combatants_players_moves
end
