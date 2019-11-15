# frozen_string_literal: true

module AccountCombatants
  class CalculateHealth < ApplicationService
    include EffectiveLevel

    MAX_BASE = AccountCombatant::MAX_BASE
    MAX_HEALTH = AccountCombatant::MAX_HEALTH
    MAX_IV = AccountCombatant::MAX_IV
    MAX_LEVEL = AccountCombatant::MAX_LEVEL
    MULTIPLIER =
      (MAX_HEALTH - MAX_LEVEL - 9) / ((MAX_BASE + MAX_IV) * MAX_LEVEL)

    # @return [Integer]
    attr_reader :value

    # @param account_combatant [AccountCombatant]
    def initialize(account_combatant)
      @account_combatant = account_combatant
    end

    # @return [void]
    def perform
      raw_value =
        (MULTIPLIER * effective_base * effective_level) + effective_level + 9
      @value = raw_value.round
    end

    private

    # @return [AccountCombatant]
    attr_reader :account_combatant

    # @!method combatant
    #   @return [Combatant]
    delegate :combatant, to: :account_combatant

    # @return [Integer]
    def base_health
      @base_health ||= combatant.base_health
    end

    # @return [Integer]
    def effective_base
      base_health + individual_health
    end

    # @return [Integer]
    def individual_health
      @individual_health ||= account_combatant.individual_health
    end

    # @return [Integer]
    def level
      @level ||=
        AccountCombatants::CalculateLevel.with(account_combatant).value
    end
  end
end
