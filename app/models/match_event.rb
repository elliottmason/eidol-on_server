class MatchEvent < ApplicationRecord
  belongs_to :board_position, optional: true
  belongs_to :match_combatant
  belongs_to :match_turns_move
  belongs_to :move_effect
  has_one :match_turn, through: :match_turns_move
end
