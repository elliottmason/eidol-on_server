# frozen_string_literal: true

# A snapshot based on a [PlayerCombatant] to manipulate in the context of a
# [Match]
class MatchCombatant < ApplicationRecord
  belongs_to :match
  belongs_to :player_combatant
  has_many :board_positions, through: :statuses
  has_many :match_combatants_moves, dependent: :restrict_with_exception
  has_many :moves, through: :match_combatants_moves
  has_many :statuses,
           class_name: 'MatchCombatantStatus',
           dependent: :restrict_with_exception
  has_one :combatant, through: :player_combatant
  has_one :player, through: :player_combatant

  # @!method statuses()
  #   @return [String]

  # @return [BoardPosition]
  def position
    status.board_position
  end

  # @return [MatchCombatantStatus]
  def status
    statuses.order('created_at DESC').first
  end
end
