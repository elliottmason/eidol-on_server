# frozen_string_literal: true

# Records a [MatchCombatantsMove] being selected, assuming for some reason that
# the player who owns the [MatchCombatant] is definitely the one who selected
# the move
class MatchMoveSelection < ApplicationRecord
  belongs_to :board_position
  belongs_to :match_combatants_move
  belongs_to :match_turn
  belongs_to :source_board_position, class_name: 'BoardPosition'
end
