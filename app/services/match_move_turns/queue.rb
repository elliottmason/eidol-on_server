# frozen_string_literal: true

module MatchMoveTurns
  # Adds a Move's MoveTurns to the MatchMoveTurns queue to be processed
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

    # @return [Array<MatchMoveTurn>]
    def perform
      ActiveRecord::Base.transaction do
        # @param move_turn [MoveTurn]
        move_turns.each do |move_turn|
          create_match_move_turn(move_turn)
        end
      end
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

    # @param move_turn [MoveTurn]
    # @return [MatchMoveTurn]
    def create_match_move_turn(move_turn)
      match_turn =
        MatchTurns::FindOrCreateForMoveTurn \
        .for(match: match, move_turn: move_turn).match_turn

      MatchMoveTurn.create!(
        match_combatant: match_combatant,
        match_move_selection: match_move_selection,
        match_turn: match_turn,
        move_turn: move_turn
      )
    end

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
