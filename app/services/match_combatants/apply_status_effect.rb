# frozen_string_literal: true

module MatchCombatants
  class ApplyStatusEffect < ApplicationService
    def initialize(amount:, combatant:, type:)
      @amount = amount
      @combatant = combatant
      @type = type
    end

    def perform; end

    private

    attr_reader :amount

    attr_reader :combatant

    attr_reader :type
  end
end
