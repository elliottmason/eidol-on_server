# frozen_string_literal: true

module MatchCombatants
  # Decrease or increase the [MatchCombatant] energy based on the energy cost of
  # the [Move]
  class AdjustRemainingEnergy < ApplicationService
    def initialize(match_combatant:, move: nil)
      @match_combatant = match_combatant
      @move = move
    end

    def perform
      status.remaining_energy = remaining_energy
      status.save!
    end

    private

    attr_reader :match_combatant

    attr_reader :move

    def combatant
      match_combatant.combatant
    end

    def energy_cost
      move ? move.energy_cost : 0
    end

    def maximum_energy
      match_combatant.maximum_energy
    end

    def remaining_energy
      energy_difference = combatant.energy_per_turn - energy_cost
      potential_value = match_combatant.remaining_energy + energy_difference
      potential_value < maximum_energy ? potential_value : maximum_energy
    end

    def status
      @status ||= match_combatant.status.dup
    end
  end
end
