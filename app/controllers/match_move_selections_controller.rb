class MatchMoveSelectionsController < ApplicationController
  def create
    MatchMoveSelections::Create.with params[:match_move_selections]
  end
end
