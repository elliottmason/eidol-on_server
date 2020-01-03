# frozen_string_literal: true

module AccountCombatants
  # Does what it says it does
  class CalculateAgility < ApplicationService
    include EffectiveLevel

    MAX_AGILITY = AccountCombatant::MAX_STAT
    MAX_BASE = AccountCombatant::MAX_BASE
    MAX_IV = AccountCombatant::MAX_IV
    MAX_LEVEL = AccountCombatant::MAX_LEVEL

    # @type [Float]
    MULTIPLIER = MAX_AGILITY / ((MAX_BASE + MAX_IV) * MAX_LEVEL)

    # @return [Integer, nil]
    attr_reader :value

    # @param account_combatant[AccountCombatant]
    def initialize(account_combatant)
      @account_combatant = account_combatant
    end

    # @return [Integer]
    def perform
      @value = (MULTIPLIER * effective_agility * effective_level).round
    end

    private

    # @return [AccountCombatant]
    attr_reader :account_combatant

    # @return [Integer]
    def base_agility
      combatant.base_agility
    end

    # @!method combatant()
    #   @return [Combatant]
    delegate :combatant, to: :account_combatant

    # @return [Integer]
    def effective_agility
      base_agility + individual_agility
    end

    # @!method individual_agility()
    #   @return [Integer]
    delegate :individual_agility, to: :account_combatant
  end
end
