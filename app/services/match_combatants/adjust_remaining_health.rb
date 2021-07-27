# frozen_string_literal: true

module MatchCombatants
  # Insert a new [MatchCombatantStatus] for the given [MatchCombatant] that has
  # a #remaining_health value added to the provided amount
  class AdjustRemainingHealth < ApplicationService
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

    def perform
      ActiveRecord::Base.transaction do
        new_status.update!(remaining_health: adjusted_remaining_health)
        MatchCombatants::UpdateAvailability.with(match_combatant)
      end
    end

    private

    attr_reader :amount

    attr_reader :match_combatant

    def adjusted_remaining_health
      return @adjusted_remaining_health if @adjusted_remaining_health

      potential_remaining_health = new_status.remaining_health + amount

      if potential_remaining_health > maximum_health
        return @adjusted_remaining_health = maximum_health
      end

      if potential_remaining_health.negative?
        return @adjusted_remaining_health = 0
      end

      @adjusted_remaining_health = potential_remaining_health
    end

    def maximum_health
      match_combatant.maximum_health
    end

    def new_status
      @new_status ||= match_combatant.status.dup
    end
  end
end
