# frozen_string_literal: true

module AccountCombatants
  class CalculateLevel < ApplicationService
    # @param account_combatant [AccountCombatant]
    def initialize(account_combatant)
      @account_combatnat = account_combatant
    end

    def perform
      @value = 1
    end
  end
end
