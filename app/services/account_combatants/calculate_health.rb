# frozen_string_literal: true

module AccountCombatants
  class CalculateHealth < ApplicationService
    MAX_BASE = 255

    MAX_HEALTH = 999

    MAX_IV = 31

    MAX_LEVEL = 25

    # @type [Integer]
    MULTIPLIER = (MAX_HEALTH - MAX_LEVEL - MAX_IV) / MAX_BASE.to_f

    # @param account_combatant [AccountCombatant]
    def initialize(account_combatant)
      @account_combatant = account_combatant
    end

    # @return [void]
    def perform
      @value =
        (
          (((MULTIPLIER * base_health) + iv) * (level + low_level_bonus)) /
          MAX_LEVEL.to_f
        ) + level + low_level_bonus
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
    def iv
      @iv ||= account_combatant.individual_health
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
