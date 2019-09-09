# frozen_string_literal: true

module MoveTurnEffects
  # Calculate the damage output of a [MoveTurnEffect] based on its properties
  # and the attacking/defending [MatchCombatant]s
  class CalculateDamage < ApplicationService
    # @return [Integer]
    attr_reader :value

    # @param move_turn_effect [MoveTurnEffect]
    # @param source_combatant [MatchCombatant]
    # @param target_combatant [MatchCombatant]
    def initialize(
      move_turn_effect:,
      source_combatant:,
      target_combatant:
    )
      @move_turn_effect = move_turn_effect
      @source_combatant = source_combatant
      @target_combatant = target_combatant
    end

    # TODO: This does math
    # @return [Integer]
    def perform
      @value = 50
    end
  end
end
