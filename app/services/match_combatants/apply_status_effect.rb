# frozen_string_literal: true

module MatchCombatants
  class ApplyStatusEffect < ApplicationService
    # @param amount [Integer]
    # @param combatant [MatchCombatant]
    # @param type [Symbol]
    def initialize(amount:, combatant:, type:)
      @amount = amount
      @combatant = combatant
      @type = type
    end

    def perform; end

    private

    # @return [Integer]
    attr_reader :amount

    # @return [MatchCombatant]
    attr_reader :combatant

    # @return [String]
    attr_reader :type
  end
end
