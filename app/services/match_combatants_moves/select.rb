# frozen_string_literal: true

module MatchCombatantsMoves
  # Create a [MatchMoveSelection] record and queue up the [MatchMoveTurn]s from
  # the associated [Move]
  class Select < ApplicationService
    # @param board_position [BoardPosition]
    # @param match_combatants_move [MatchCombatantsMove]
    # @param match_turn [MatchTurn]
    def initialize(
      board_position:,
      match_combatants_move:,
      match_turn:,
    )
      @board_position = board_position
      @match_combatants_move = match_combatants_move
      @match_turn = match_turn
    end

    # @return [NilClass]
    def perform
      ActiveRecord::Base.transaction do
        match_move_selection = create_selection
        queue_match_move_turns(match_move_selection)
      end
    end

    private

    # @return [BoardPosition]
    attr_reader :board_position

    # @return [MatchCombatantsMove]
    attr_reader :match_combatants_move

    # @return [MatchTurn]
    attr_reader :match_turn

    # @return [MatchMoveSelection]
    def create_selection
      MatchMoveSelection.create!(
        board_position: board_position,
        match_combatants_move: match_combatants_move,
        match_turn: match_turn,
      )
    end

    # @param [MatchMoveSelection]
    #        match_move_selection
    # @return [MatchMoveTurns::Queue]
    def queue_match_move_turns(match_move_selection)
      MatchMoveTurns::Queue.for(
        match_combatant: match_combatants_move.match_combatant,
        match_move_selection: match_move_selection,
        match_turn: match_turn,
        move: match_combatants_move.move
      )
    end
  end
end
