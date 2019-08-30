# frozen_string_literal: true

module MatchTurnsMoveTurns
  # Adds a Move's MoveTurns to the MatchTurnsMoveTurns queue to be processed
  class Queue < ApplicationService
    # @param combatants_players_match [CombatantsPlayersMatch]
    # @param match_turn [MatchTurn]
    # @param move [Move]
    def initialize(
      combatants_players_match:,
      match_turn:,
      move:
    )
      @combatants_players_match = combatants_players_match
      @match_turn = match_turn
      @move = move
    end

    # @return [Array<MatchTurnsMoveTurn>]
    def perform
      ActiveRecord::Base.transaction do
        # @param move_turn [MoveTurn]
        move_turns.each do |move_turn|
          MatchTurnsMoveTurn.create!(
            combatants_players_match: combatants_players_match,
            match_turn:
              MatchTurns::FindOrCreate.for(match: match, move_turn: move_turn),
            move_turn: move_turn
          )
        end
      end
    end

    private

    # @return [CombatantsPlayersMatch]
    attr_reader :combatants_players_match

    # @return [MatchTurn]
    attr_reader :match_turn

    # @return [Move]
    attr_reader :move

    # @return [Match]
    def match
      match_turn.match
    end

    # @return [Array<MoveTurn>]
    def move_turns
      move.turns.all
    end
  end
end
