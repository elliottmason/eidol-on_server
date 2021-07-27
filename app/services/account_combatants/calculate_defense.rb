# frozen_string_literal: true

module AccountCombatants
  # This should be somewhat self-explanatory really.
  class CalculateDefense < ApplicationService
    include EffectiveLevel

    MAX_BASE = AccountCombatant::MAX_BASE
    MAX_IV = AccountCombatant::MAX_IV
    MAX_DEFENSE = AccountCombatant::MAX_STAT
    MAX_LEVEL = AccountCombatant::MAX_LEVEL
    MULTIPLIER = MAX_DEFENSE / ((MAX_BASE + MAX_IV) * MAX_LEVEL)

    attr_reader :value

    def initialize(account_combatant)
      @account_combatant = account_combatant
    end

    def perform
      @value = (MULTIPLIER * effective_defense * effective_level).round
    end

    private

    attr_reader :account_combatant

    def base_defense
      combatant.base_defense
    end

    def combatant
      @combatant ||= account_combatant.combatant
    end

    def effective_defense
      base_defense + individual_defense
    end

    def individual_defense
      account_combatant.individual_defense
    end
  end
end
