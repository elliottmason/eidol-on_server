class CombatantsPlayersMove < ApplicationRecord
  belongs_to :combatants_player
  belongs_to :move
end
