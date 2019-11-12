# frozen_string_literal: true

module AccountCombatants
  class CalculateDefense < ApplicationService
    MAX_BASE = 255

    MAX_DEFENSE = 999

    MAX_IV = 31

    # @type [Integer]
    MULTIPLIER = (MAX_DEFENSE - MAX_IV) / MAX_BASE

    # @param account_combatant [AccountCombatant]
    def initialize(account_combatant)
      @account_combatant = account_combatant
    end

    # @return [void]
    def perform
      @value = ((MULTIPLIER * base_defense) + iv) * level
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
    def iv
      account_combatant.individual_defense
    end

    # @return [Integer]
    def level
      @level ||=
        AccountCombatants::CalculateLevel.with(account_combatant).value
    end
  end
end
