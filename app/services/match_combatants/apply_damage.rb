# frozen_string_literal: true

module MatchCombatants
  # Insert a new [MatchCombatantStatus] for the given [MatchCombatant] that has
  # a #remaining_health value reduced by the provided amount
  class ApplyDamage < ApplicationService
    # @param amount [Integer]
    # @param combatant [MatchCombatant]
    def initialize(
      amount:,
      combatant:
    )
      @amount = amount
      @combatant = combatant
    end

    def perform
      new_status = combatant.status.dup
      new_status.remaining_health -= amount
      new_status.save!
    end

    private

    # @return [Integer]
    attr_reader :amount

    # @return [MatchCombatant]
    attr_reader :combatant
  end
end
