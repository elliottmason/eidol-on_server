# frozen_string_literal: true

module MatchTurnsMoves
  # Adds a [Move] to the [MatchTurnsMove]s queue to be processed
  class Queue < ApplicationService
    # @param match_move_selection [MatchMoveSelection, nil]
    # @param match_combatant [MatchCombatant]
    # @param match_turn [MatchTurn]
    # @param move [Move]
    def initialize(
      match_move_selection: nil,
      match_combatant:,
      match_turn:,
      move:
    )
      @match_combatant = match_combatant
      @match_move_selection = match_move_selection
      @match_turn = match_turn
      @move = move
    end

    # @return [void]
    def perform
      create_match_turns_move(move)
    end

    private

    # @return [MatchCombatant]
    attr_reader :match_combatant

    # @return [MatchMoveSelection, nil]
    attr_reader :match_move_selection

    # @return [MatchTurn]
    attr_reader :match_turn

    # @return [Move]
    attr_reader :move

    # @param move [Move]
    # @return [MatchTurnsMove]
    def create_match_turns_move(move)
      match_turn =
        MatchTurns::FindOrCreateForMove \
        .for(match: match, move: move).match_turn

      MatchTurnsMove.create!(
        match_combatant: match_combatant,
        match_move_selection: match_move_selection,
        match_turn: match_turn,
        move: move
      )
    end

    # @return [Match]
    def match
      match_turn.match
    end
  end
end
