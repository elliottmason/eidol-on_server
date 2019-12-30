# frozen_string_literal: true

module MatchCombatants
  # Insert a new [MatchCombatantStatus] for the given [MatchCombatant] that has
  # a #remaining_health value added to the provided amount
  class AdjustRemainingHealth < ApplicationService
    # @param amount [Integer]
    # @param match_combatant [MatchCombatant]
    def initialize(
      amount:,
      match_combatant:
    )
      @amount = amount
      @match_combatant = match_combatant
    end

    def allowed?
      !match_combatant.knocked_out?
    end

    # @return [void]
    def perform
      ActiveRecord::Base.transaction do
        new_status.update!(remaining_health: adjusted_remaining_health)
        MatchCombatants::UpdateAvailability.with(match_combatant)
      end
    end

    private

    # @return [Integer]
    attr_reader :amount

    # @return [MatchCombatant]
    attr_reader :match_combatant

    # @return [Integer]
    def adjusted_remaining_health
      return @adjusted_remaining_health if @adjusted_remaining_health

      # @type [Integer]
      potential_remaining_health = new_status.remaining_health + amount

      if potential_remaining_health > maximum_health
        return @adjusted_remaining_health = maximum_health
      end

      if potential_remaining_health.negative?
        return @adjusted_remaining_health = 0
      end

      @adjusted_remaining_health = potential_remaining_health
    end

    # @return [Integer]
    def maximum_health
      match_combatant.maximum_health
    end

    # @return [MatchCombatantStatus]
    def new_status
      @new_status ||= match_combatant.status.dup
    end
  end
end
