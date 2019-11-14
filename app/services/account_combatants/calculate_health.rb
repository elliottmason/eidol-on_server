# frozen_string_literal: true

module AccountCombatants
  class CalculateHealth < ApplicationService
    MAX_HEALTH = AccountCombatant::MAX_HEALTH

    MAX_IV = AccountCombatant::MAX_IV

    MAX_LEVEL = AccountCombatant::MAX_LEVEL

    MULTIPLIER = (MAX_HEALTH - MAX_LEVEL - MAX_IV) / MAX_HEALTH

    # @return [Integer]
    attr_reader :value

    # @param account_combatant [AccountCombatant]
    def initialize(account_combatant)
      @account_combatant = account_combatant
    end

    # @return [void]
    def perform
      @value =
        (
          (
            ((MULTIPLIER * base_health) + individual_health) *
            effective_level
          ) / MAX_LEVEL
        ) + effective_level
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
    def effective_level
      level + low_level_bonus
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

    # @return [Integer]
    def low_level_bonus
      (MAX_LEVEL - level) / MAX_LEVEL
    end
  end
end
