# A snapshot of a Player's Combatant to manipulate in the context of a match
class CombatantsPlayersMatch < ApplicationRecord
  belongs_to :combatants_player
  belongs_to :match
end
