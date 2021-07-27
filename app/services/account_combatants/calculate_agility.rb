# frozen_string_literal: true

module AccountCombatants
  # Does what it says it does
  class CalculateAgility < ApplicationService
    include EffectiveLevel

    MAX_AGILITY = AccountCombatant::MAX_STAT
    MAX_BASE = AccountCombatant::MAX_BASE
    MAX_IV = AccountCombatant::MAX_IV
    MAX_LEVEL = AccountCombatant::MAX_LEVEL
    MULTIPLIER = MAX_AGILITY / ((MAX_BASE + MAX_IV) * MAX_LEVEL)

    attr_reader :value

    def initialize(account_combatant)
      @account_combatant = account_combatant
    end

    def perform
      @value = (MULTIPLIER * effective_agility * effective_level).round
    end

    private

    attr_reader :account_combatant

    def base_agility
      combatant.base_agility
    end

    delegate :combatant, to: :account_combatant

    def effective_agility
      base_agility + individual_agility
    end

    delegate :individual_agility, to: :account_combatant
  end
end
