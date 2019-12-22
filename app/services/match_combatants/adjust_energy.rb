# frozen_string_literal: true

module MatchCombatants
  # Decrease or increase the [MatchCombatant] energy based on the energy cost of
  # the [MoveTurn]
  class AdjustEnergy < ApplicationService
    # @param match_combatant [MatchCombatant]
    # @param move [Move]
    def initialize(match_combatant:, move:)
      @match_combatant = match_combatant
      @move = move
    end

    def perform
      ActiveRecord::Base.transaction do
        status.remaining_energy = remaining_energy
        status.save!
      end
    end

    private

    # @return [MatchCombatant]
    attr_reader :match_combatant

    # @return [Move]
    attr_reader :move

    # @return [Combatant]
    def combatant
      match_combatant.combatant
    end

    # @return [Integer]
    def remaining_energy
      energy_difference = combatant.energy_per_turn - move.energy_cost
      match_combatant.remaining_energy + energy_difference
    end

    # @return [MatchCombatantStatus]
    def status
      @status ||= match_combatant.status.dup
    end
  end
end
