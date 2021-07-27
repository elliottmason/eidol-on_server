# frozen_string_literal: true

module MatchTurnsMoves
  # Adds a [Move] to the [MatchTurnsMove]s queue to be processed
  class Queue < ApplicationService
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

    def perform
      create_match_turns_move(move)
    end

    private

    attr_reader :match_combatant

    attr_reader :match_move_selection

    attr_reader :match_turn

    attr_reader :move

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

    def match
      match_turn.match
    end
  end
end
