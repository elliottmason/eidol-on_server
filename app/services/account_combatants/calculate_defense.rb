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

    # @return [Integer]
    attr_reader :value

    # @param account_combatant [AccountCombatant]
    def initialize(account_combatant)
      @account_combatant = account_combatant
    end

    # @return [void]
    def perform
      @value = (MULTIPLIER * effective_defense * effective_level).round
    end

    private

    # @return [AccountCombatant]
    attr_reader :account_combatant

    # @return [Integer]
    def base_defense
      combatant.base_defense
    end

    # @return [Combatant]
    def combatant
      @combatant ||= account_combatant.combatant
    end

    # @return [Integer]
    def effective_defense
      base_defense + individual_defense
    end

    # @return [Integer]
    def individual_defense
      account_combatant.individual_defense
    end
  end
end
