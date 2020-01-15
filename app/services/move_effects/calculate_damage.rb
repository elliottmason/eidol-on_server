# frozen_string_literal: true

module MoveEffects
  # Calculate the damage output of a [MoveEffect] based on its properties
  # and the attacking/defending [MatchCombatant]s
  class CalculateDamage < ApplicationService
    include AccountCombatants::EffectiveLevel

    MULTIPLIER = 10

    # @return [Integer]
    attr_reader :value

    # @param move_effect [MoveEffect]
    # @param source_combatant [MatchCombatant]
    # @param target_combatant [MatchCombatant]
    def initialize(
      move_effect:,
      source_combatant:,
      target_combatant:
    )
      @move_effect = move_effect
      @source_combatant = source_combatant
      @target_combatant = target_combatant
    end

    # @return [void]
    def perform
      if move_effect.property == 'direct'
        return @value = move_effect.power
      end

      raw_value =
       (MULTIPLIER * effective_level * effective_power / defense) *
       rand(0.85..1)
      @value = raw_value.round
    end

    # @return [Boolean]
    def successful?
      value.present?
    end

    private

    # @return [MoveEffect]
    attr_reader :move_effect

    # @return [MatchCombatant]
    attr_reader :source_combatant

    # @return [MatchCombatant]
    attr_reader :target_combatant

    # @return [Integer]
    def defense
      target_combatant.defense
    end

    # @return [Float]
    def effective_power
      power + (individual_power / 3.1)
    end

    # @return [Integer]
    def individual_power
      source_combatant.individual_power
    end

    # @return [Integer]
    def level
      source_combatant.level
    end

    # TODO: calculate modifier (in another service?)
    # @return [Integer]
    def modifier
      1
    end

    # @return [Integer]
    def power
      move_effect.power
    end
  end
end
