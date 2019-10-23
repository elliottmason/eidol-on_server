# frozen_string_literal: true

# Tracks a [MatchCombatant]'s stats and [BoardPosition] as it transforms during
# a match
class MatchCombatantStatus < ApplicationRecord
  belongs_to :board_position, optional: true
  belongs_to :match_combatant
  belongs_to :match_event, optional: true

  enum availability: {
    available: 'available',
    benched: 'benched',
    knocked_out: 'knocked_out'
  }

  # @!attribute [rw] availability
  #   @return [String]

  # @!attribute [rw] maximum_health
  #   @return [Integer]

  # @!attribute [rw] remaining_health
  #   @return [Integer]

  # @!method available!
  #   @return [Boolean]

  # @!method available?
  #   @return [Boolean]

  # @!method benched!
  #   @return [Boolean]

  # @!method benched?
  #   @return [Boolean]

  # @!method knocked_out!
  #   @return [Boolean]

  # @!method knocked_out?
  #   @return [Boolean]

  # @!method unavailable!
  #   @return [Boolean]

  # @!method unavailable?
  #   @return [Boolean]
end
