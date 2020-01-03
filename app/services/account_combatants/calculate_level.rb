# frozen_string_literal: true

module AccountCombatants
  # Calculates an AccountCombatant's level based on its experience
  class CalculateLevel < ApplicationService
    EXPONENT = (1.0 / 3)

    # @return [Integer]
    attr_reader :value

    # @param account_combatant [AccountCombatant]
    def initialize(account_combatant)
      @exp = account_combatant.status.exp
    end

    def perform
      @value = (exp ** EXPONENT).round
    end

    private

    # @return [Integer]
    attr_reader :exp
  end
end
