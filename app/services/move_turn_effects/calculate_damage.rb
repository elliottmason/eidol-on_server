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

    # @return [void]
    def perform
      @value = (((level_quotient * power_quotient) + 2) * modifier).round
    end

    # @return [Boolean]
    def successful?
      value.present?
    end

    private

    # @return [MoveTurnEffect]
    attr_reader :move_turn_effect

    # @return [MatchCombatant]
    attr_reader :source_combatant

    # @return [MatchCombatant]
    attr_reader :target_combatant

    # @return [Integer]
    def attack
      source_combatant.attack
    end

    # @return [Integer]
    def defense
      source_combatant.defense
    end

    # @return [Integer]
    def level
      source_combatant.level
    end

    # TODO: questionable semantics
    # @return [Float]
    def level_quotient
      2 + ((2.0 * level) / 5.0)
    end

    # TODO: calculate modifier (in another service?)
    # @return [Integer]
    def modifier
      1
    end

    # @return [Integer]
    def power
      move_turn_effect.power
    end

    # @return [Float]
    def power_quotient
      power * (attack / defense.to_f) / 50.0
    end
  end
end
