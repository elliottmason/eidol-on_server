# frozen_string_literal: true

module MatchMoveSelections
  class CreateFromParams < ApplicationService
    def initialize(
      board_position_id:,
      match_combatants_move_id:
    )
      @board_position_id = board_position_id.to_i
      @match_combatants_move_id = match_combatants_move_id.to_i
    end

    def perform
      MatchMoveSelections::Create.with(
        board_position: board_position,
        match_combatants_move: match_combatants_move
      )
    end

    private

    attr_reader :board_position_id

    attr_reader :match_combatants_move_id

    def board_position
      @board_position ||= BoardPosition.find_by(id: board_position_id)
    end

    def match_combatants_move
      @match_combatants_move ||=
        MatchCombatantsMove.find_by(id: match_combatants_move_id)
    end
  end
end
