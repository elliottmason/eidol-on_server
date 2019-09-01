# frozen_string_literal: true

# A snapshot based on a [PlayerCombatant] to manipulate in the context of a
# [Match]
class MatchCombatant < ApplicationRecord
  belongs_to :match
  belongs_to :player_combatant
  has_many :board_positions_match_combatants
  has_many :board_positions, through: :board_positions_match_combatants
  has_many :match_combatants_moves, dependent: :destroy
  has_many :moves, through: :match_combatants_moves
  has_many :statuses, class_name: 'MatchCombatantStatus', dependent: :destroy

  # @return [BoardPosition]
  def current_position
    current_status.board_position
  end

  # @return [MatchCombatantStatus]
  def current_status
    statuses.order('created_at DESC').first
  end
end
