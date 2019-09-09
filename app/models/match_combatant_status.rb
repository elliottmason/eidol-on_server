# frozen_string_literal: true

# Tracks a [MatchCombatant]'s stats and [BoardPosition] as it transforms during
# a match
class MatchCombatantStatus < ApplicationRecord
  belongs_to :board_position, optional: true
  belongs_to :match_combatant
  belongs_to :match_event, optional: true

  # @!method remaining_health()
  #   @return [Integer]
end
