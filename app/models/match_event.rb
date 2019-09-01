class MatchEvent < ApplicationRecord
  belongs_to :board_position, optional: true
  belongs_to :match_combatant
  belongs_to :match_move_turn
  belongs_to :move_turn_effect
end
