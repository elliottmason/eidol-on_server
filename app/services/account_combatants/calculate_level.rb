# frozen_string_literal: true

module AccountCombatants
  # Calculates an AccountCombatant's level based on its experience
  class CalculateLevel < ApplicationService
    EXPONENT = (1.0 / 3)

    attr_reader :value

    def initialize(account_combatant)
      @exp = account_combatant.status.exp
    end

    def perform
      @value = (exp ** EXPONENT).round
    end

    private

    attr_reader :exp
  end
end
