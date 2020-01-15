# frozen_string_literal: true

# The effective queue of [Move]s for a [MatchTurn], and the [MatchCombatant]
# that is using the move
class MatchTurnsMove < ApplicationRecord
  belongs_to :match_move_selection, optional: true
  belongs_to :match_combatant
  belongs_to :match_turn
  belongs_to :move
  has_one :match, through: :match_turn
  has_many :match_events, dependent: :restrict_with_exception

  delegate :board_position, to: :match_move_selection

  # @return [ActiveRecord::Relation<MatchTurnsMove>]
  def self.unprocessed
    where(processed_at: nil)
  end

  # @!method board_position
  #   @return [BoardPosition]

  # @!attribute [rw] match_combatant
  #   @return [MatchCombatant]

  # @!attribute [rw] match_move_selection
  #   @return [MatchMoveSelection]

  # @!attribute [rw] move
  #   @return [Move]

  # @!attribute [rw] processed_at
  #   @return [DateTime, nil]
end
