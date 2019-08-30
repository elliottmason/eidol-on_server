# frozen_string_literal: true

module CombatantsPlayersMatchesMoves
  # Create a CombatantsPlayersMatchesMoveSelection record and queue up the
  # MoveTurns from the associated Move
  class Select < ApplicationService
    def initialize(
      board_position:,
      combatants_players_matches_move:,
      match_turn:
    )
      @board_position = board_position
      @combatants_players_matches_move = combatants_players_matches_move
      @match_turn = match_turn
    end

    def perform
      ActiveRecord::Base.transaction do
        create_selection
        MatchTurnsMoveTurns::Queue.for(
          combatants_players_match:
            combatants_players_matches_move.combatants_players_match,
          match_turn: match_turn,
          move: combatants_players_matches_move.move
        )
      end
    end

    private

    attr_reader :board_position
    attr_reader :combatants_players_matches_move
    attr_reader :match_turn

    def create_selection
      CombatantsPlayersMatchesMoveSelection.create(
        board_position: board_position,
        combatants_players_matches_move: combatants_players_matches_move,
        match_turn: match_turn
      )
    end
  end
end
