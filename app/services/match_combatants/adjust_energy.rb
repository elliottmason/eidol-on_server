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
      MatchCombatantStatus.create!(
        match_combatant: match_combatant,
        remaining_energy: remaining_energy
      )
    end

    private

    # @return [MatchCombatant]
    attr_reader :match_combatant
    
    # @return [Move]
    attr_reader :move

    # @return [Integer]
    def remaining_energy

    end
  end
end
