# frozen_string_literal: true

module MatchCombatants
  # Creates a copy of a Player's Combatant that can be manipulated in the
  # context of a Match
  class Create < ApplicationService
    # @return [MatchCombatant]
    attr_reader :match_combatant

    # @param match [Match]
    # @param player_combatant [PlayerCombatant]
    def initialize(match:, player_combatant:)
      @match = match
      @player_combatant = player_combatant
    end

    # TODO: create real stats
    def perform
      ActiveRecord::Base.transaction do
        copy_combatant
        create_combatant_status
        copy_moves
      end
    end

    private

    # @return [Match]
    attr_reader :match

    # @return [PlayerCombatant]
    attr_reader :player_combatant

    # @return [MatchCombatant]
    def copy_combatant
      @match_combatant =
        MatchCombatant.create!(
          player_combatant: player_combatant,
          match: match,
          defense: 1,
          health: 1,
          level: 1
        )
    end

    # TODO: could this be its own service?
    # @return [Array<MatchCombatantsMove>]
    def copy_moves
      player_combatant.moves.map do |move|
        MatchCombatantsMove.create!(
          match_combatant: match_combatant,
          move: move
        )
      end
    end

    def create_combatant_status
      health = match_combatant.health
      MatchCombatantStatus.create!(
        match_combatant: match_combatant,
        defense: match_combatant.defense,
        level: match_combatant.level,
        maximum_energy: 15,
        maximum_health: health,
        remaining_energy: 2,
        remaining_health: health,
        availability: 'benched'
      )
    end
  end
end
