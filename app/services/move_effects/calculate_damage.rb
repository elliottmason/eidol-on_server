# frozen_string_literal: true

module MoveEffects
  # Calculate the damage output of a [MoveEffect] based on its properties
  # and the attacking/defending [MatchCombatant]s
  class CalculateDamage < ApplicationService
    include AccountCombatants::EffectiveLevel

    MULTIPLIER = 10

    attr_reader :value

    def initialize(
      move_effect:,
      source_combatant:,
      target_combatant:
    )
      @move_effect = move_effect
      @source_combatant = source_combatant
      @target_combatant = target_combatant
    end

    def perform
      if move_effect.property == 'direct'
        return @value = move_effect.power
      end

      raw_value =
       (MULTIPLIER * effective_level * effective_power / defense) *
       rand(0.85..1)
      @value = raw_value.round
    end

    def successful?
      value.present?
    end

    private

    attr_reader :move_effect

    attr_reader :source_combatant

    attr_reader :target_combatant

    def defense
      target_combatant.defense
    end

    def effective_power
      power + (individual_power / 3.1)
    end

    def individual_power
      source_combatant.individual_power
    end

    def level
      source_combatant.level
    end

    # TODO: calculate modifier (in another service?)
    def modifier
      1
    end

    def power
      move_effect.power
    end
  end
end
