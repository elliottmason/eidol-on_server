# frozen_string_literal: true

module MatchCombatantsMoves
  # Create a [MatchMoveSelection] record and queue up the [MatchMoveTurn]s from
  # the associated [Move]
  class Select < ApplicationService
    # @param board_position [BoardPosition]
    # @param match_combatants_move [MatchCombatantsMove]
    # @param match_turn [MatchTurn]
    # @param source_board_position [BoardPosition]
    def initialize(
      board_position:,
      match_combatants_move:,
      match_turn:,
      source_board_position:
    )
      @board_position = board_position
      @match_combatants_move = match_combatants_move
      @match_turn = match_turn
      @source_board_position = source_board_position
    end

    # @return [NilClass]
    def perform
      ActiveRecord::Base.transaction do
        match_move_selection = create_selection
        queue_match_move_turn(match_move_selection)
      end
    end

    private

    # @return [BoardPosition]
    attr_reader :board_position

    # @return [MatchCombatantsMove]
    attr_reader :match_combatants_move

    # @return [MatchTurn]
    attr_reader :match_turn

    # @return [BoardPosition]
    attr_reader :source_board_position

    # @return [MatchMoveSelection]
    def create_selection
      MatchMoveSelection.create!(
        board_position: board_position,
        match_combatants_move: match_combatants_move,
        match_turn: match_turn,
        source_board_position: source_board_position
      )
    end

    # @param [MatchMoveSelection]
    #        match_move_selection
    # @return [MatchMoveTurns::Queue]
    def queue_match_move_turn(match_move_selection)
      MatchMoveTurns::Queue.for(
        match_combatant: match_combatants_move.match_combatant,
        match_move_selection: match_move_selection,
        match_turn: match_turn,
        move: match_combatants_move.move
      )
    end
  end
end
