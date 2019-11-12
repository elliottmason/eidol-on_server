# frozen_string_literal: true

# base = 0
# iv = 0
# level = 0

# max_base = 255.to_f
# max_health = 999.to_f
# max_iv = 31.to_f
# max_level = 25.to_f

# multiplier = (max_health - max_level - max_iv) / max_base

# ((((multiplier*base)+iv)*(level+1)) / (max_level + 1)) +
# ((max_level-level)/max_level) + level

module AccountCombatants
  class CalculateHealth < ApplicationService
    # @type [Integer]
    MAX_BASE = 255

    # @type [Integer]
    MAX_HEALTH = 999

    # @type [Integer]
    MAX_IV = 31

    # @type [Integer]
    MAX_LEVEL = 25

    # @type [Integer]
    MULTIPLIER = (MAX_HEALTH - MAX_LEVEL - MAX_IV) / MAX_BASE

    # @param account_combatant [AccountCombatant]
    def initialize(account_combatant)
      @account_combatant = account_combatant
    end

    # @return [void]
    def perform
      @value =
        ((((MULTIPLIER * base_health) + iv) * (level + 1)) / (MAX_LEVEL + 1)) +
        low_level_bonus + level
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
