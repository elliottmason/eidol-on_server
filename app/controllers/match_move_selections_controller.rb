# frozen_string_literal: true

class MatchMoveSelectionsController < ApplicationController
  def create
    MatchMoveSelections::CreateFromParamsArray.with(create_params)
  end

  private

  def create_params
    params.require(:match_move_selections).map do |param|
      param.permit(:board_position_id, :match_combatants_move_id)
    end
  end
end
