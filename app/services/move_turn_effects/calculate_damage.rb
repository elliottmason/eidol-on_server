# frozen_string_literal: true

# Calculate the damage output of a [MoveTurnEffect] based on the properties of
# the
module MoveTurnEffects
  class CalculateDamage < ApplicationService
    # @return [Integer]
    attr_reader :value

    # @param move_turn_effect [MoveTurnEffect]
    # @param source_combatant [MatchCombatant]
    # @param target_combatant [MatchCombatant]
    def initialize(
      move_turn_effect:,
      target_combatant:
    )
      @move_turn_effect = move_turn_effect
      @target_combatant = target_combatant
    end

    def perform

    end
  end
end
