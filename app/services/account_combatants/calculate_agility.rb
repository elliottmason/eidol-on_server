# frozen_string_literal: true

module AccountCombatants
  class CalculateAgility < ApplicationService
    include EffectiveLevel

    # @return [Integer]
    attr_reader :value

    # @param account_combatant [AccountCombatant]
    def initialize(account_combatant)
      @account_combatant = account_combatant
    end

    # TODO
    # @return [void]
    def perform
      @value = 100
    end
  end
end
