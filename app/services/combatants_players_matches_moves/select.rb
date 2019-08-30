# frozen_string_literal: true

module CombatantsPlayersMatchesMoves
  # Create a CombatantsPlayersMatchesMoveSelection record and queue up the
  # MatchTurnMoveTurns from the associated Move
  class Select < ApplicationService
    # @param board_position [BoardPosition]
    # @param combatants_players_matches_move [CombatantsPlayersMatchesMove]
    # @param match_turn [MatchTurn]
    def initialize(
      board_position:,
      combatants_players_matches_move:,
      match_turn:
    )
      @board_position = board_position
      @combatants_players_matches_move = combatants_players_matches_move
      @match_turn = match_turn
    end

    # @return [NilClass]
    def perform
      ActiveRecord::Base.transaction do
        combatants_players_matches_move_selection = create_selection
        queue_match_turns_move_turn(combatants_players_matches_move_selection)
      end
    end

    private

    # @return [BoardPosition]
    attr_reader :board_position

    # @return [CombatantsPlayersMatchesMove]
    attr_reader :combatants_players_matches_move

    # @return [MatchTurn]
    attr_reader :match_turn

    # @return [CombatantsPlayersMatchesMoveSelection]
    def create_selection
      CombatantsPlayersMatchesMoveSelection.create!(
        board_position: board_position,
        combatants_players_matches_move: combatants_players_matches_move,
        match_turn: match_turn
      )
    end

    # @param [CombatantsPlayersMatchesMoveSelection]
    #        combatants_players_matches_move_selection
    # @return [MatchTurnsMoveTurns::Queue]
    def queue_match_turns_move_turn(combatants_players_matches_move_selection)
      MatchTurnsMoveTurns::Queue.for(
        combatants_players_match:
          combatants_players_matches_move.combatants_players_match,
        combatants_players_matches_move_selection:
          combatants_players_matches_move_selection,
        match_turn: match_turn,
        move: combatants_players_matches_move.move
      )
    end
  end
end
