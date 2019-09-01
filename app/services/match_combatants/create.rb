# frozen_string_literal: true

module MatchCombatants
  # Creates a copy of a Player's Combatant that can be manipulated in the
  # context of a Match
  class Create < ApplicationService
    # @return [MatchCombatant]
    attr_reader :match_combatant

    # @param match [Match]
    # @param match_combatant [PlayerCombatant]
    def initialize(match:, player_combatant:)
      @match = match
      @player_combatant = player_combatant
    end

    # TODO: create real stats
    def perform
      ActiveRecord::Base.transaction do
        copy_combatant
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
  end
end
