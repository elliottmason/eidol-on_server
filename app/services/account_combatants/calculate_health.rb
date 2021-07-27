# frozen_string_literal: true

module AccountCombatants
  # Gee, what do you think this service does?
  class CalculateHealth < ApplicationService
    include EffectiveLevel

    MAX_BASE = AccountCombatant::MAX_BASE
    MAX_HEALTH = AccountCombatant::MAX_HEALTH
    MAX_IV = AccountCombatant::MAX_IV
    MAX_LEVEL = AccountCombatant::MAX_LEVEL
    MULTIPLIER =
      (MAX_HEALTH - MAX_LEVEL - 9) / ((MAX_BASE + MAX_IV) * MAX_LEVEL)

    attr_reader :value

    def initialize(account_combatant)
      @account_combatant = account_combatant
    end

    def perform
      raw_value =
        (MULTIPLIER * effective_base * effective_level) + effective_level + 9
      @value = raw_value.round
    end

    private

    attr_reader :account_combatant

    delegate :combatant, to: :account_combatant

    def base_health
      @base_health ||= combatant.base_health
    end

    def effective_base
      base_health + individual_health
    end

    def individual_health
      @individual_health ||= account_combatant.individual_health
    end
  end
end
