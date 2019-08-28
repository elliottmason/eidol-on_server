# frozen_string_literal: true

module CombatantsPlayersMatches
  # Creates a copy of a Player's Combatant that can be manipulated in the
  # context of a Match
  class Create < ApplicationService
    attr_reader :combatants_players_match

    def initialize(combatants_player:, match:)
      @combatants_player = combatants_player
      @match = match
    end

    # TODO: create real stats
    def perform
      ActiveRecord::Base.transaction do
        copy_combatant
        copy_moves
      end
    end

    private

    attr_reader :combatants_player
    attr_reader :match

    def copy_combatant
      @combatants_players_match =
        CombatantsPlayersMatch.create!(
          combatants_player: combatants_player,
          match: match,
          defense: 1,
          health: 1,
          level: 1
        )
    end

    # TODO: could this be its own service?
    def copy_moves
      combatants_player.moves.each do |move|
        CombatantsPlayersMatchesMove.create!(
          combatants_players_match: combatants_players_match,
          move: move
        )
      end
    end
  end
end
