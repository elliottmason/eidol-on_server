# frozen_string_literal: true

module MatchMoveSelections
  class CreateFromParams < ApplicationService
    # @param board_position_id [Integer, String]
    # @param match_combatants_move_id [Integer, String]
    def initialize(
      board_position_id:,
      match_combatants_move_id:
    )
      @board_position_id = board_position_id.to_i
      @match_combatants_move_id = match_combatants_move_id.to_i
    end

    # @return [MatchMoveSelections::Create]
    def perform
      MatchMoveSelections::Create.with(
        board_position: board_position,
        match_combatants_move: match_combatants_move
      )
    end

    private

    # @return [Integer
    attr_reader :board_position_id

    # @return [Integer]
    attr_reader :match_combatants_move_id

    # @return [BoardPosition]
    def board_position
      @board_position ||= BoardPosition.find(board_position_id)
    end

    # @return [MatchCombatantsMove]
    def match_combatants_move
      @match_combatants_move ||=
        MatchCombatantsMove.find(match_combatants_move_id)
    end
  end
end
