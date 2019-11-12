# frozen_string_literal: true

module AccountCombatants
  class CalculateLevel < ApplicationService
    # @param account_combatant [AccountCombatant]
    def initialize(account_combatant)
      @account_combatnat = account_combatant
    end

    def perform
      @value = (exp ** (1/3.0)).round
    end

    private

    # @return [AccountCombatant]
    attr_reader :account_combatant

    # @return [Integer]
    def exp
      account_combatant.status.exp
    end
  end
end
