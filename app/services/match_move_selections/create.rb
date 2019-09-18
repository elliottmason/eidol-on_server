# frozen_string_literal: true

module MatchMoveSelections
  class Create < ApplicationServer
    def initialize(params_array:)
      @params_array = params_array
    end

    def perform
      params_array.each do |params|
        board_position

        MatchCombatantsMoves::Select.with(
          board_position:
            BoardPosition.find(params[:board_position_id]),
          match_combatants_move:
            MatchCombatantsMove.find(params[:match_combatants_move_id])
          match_turn:
            MatchTurn.find(params[:match_turn_id])
        )
      end
    end

    private

    attr_reader :params
  end
end