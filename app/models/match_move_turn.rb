# frozen_string_literal: true

# The effective queue of [MoveTurn]s for a [MatchTurn], and the
# [MatchCombatant] that is using the move
class MatchMoveTurn < ApplicationRecord
  belongs_to :match_move_selection, optional: true
  belongs_to :match_combatant
  belongs_to :match_turn
  belongs_to :move_turn
  has_one :match, through: :match_turn
  has_many :match_events, dependent: :restrict_with_exception

  delegate :board_position, to: :match_move_selection


  # @return [ActiveRecord::Relation<MatchMoveTurn>]
  def self.unprocessed
    where(processed_at: nil)
  end

  # @!attribute [rw] match_move_selection
  #   @return [MatchMoveSelection]

  # @!attribute [rw] move_turn
  #   @return [MoveTurn]

  # @!attribute [rw] match_combatant
  #   @return [MatchCombatant]
end
