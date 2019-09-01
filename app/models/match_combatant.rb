# frozen_string_literal: true

# A snapshot based on a [PlayerCombatant] to manipulate in the context of a
# [Match]
class MatchCombatant < ApplicationRecord
  belongs_to :player_combatant
  belongs_to :match
  has_many :board_positions_match_combatants
  has_many :board_positions, through: :board_positions_match_combatants
  has_many :match_combatants_moves, dependent: :destroy
  has_many :moves, through: :match_combatants_moves

  # @return [BoardPosition]
  def current_position
    board_positions_match_combatants.latest.first.board_position
  end
end
