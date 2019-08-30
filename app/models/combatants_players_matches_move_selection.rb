class CombatantsPlayersMatchesMoveSelection < ApplicationRecord
  belongs_to :board_position
  belongs_to :combatants_players_matches_move
  belongs_to :match_turn
end
