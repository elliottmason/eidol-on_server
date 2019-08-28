class CombatantsPlayersMatchesMove < ApplicationRecord
  belongs_to :combatants_players_match
  belongs_to :move
end
