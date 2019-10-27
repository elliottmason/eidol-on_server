# frozen_string_literal: true

class MatchMoveSelectionsController < ApplicationController
  def create
    MatchMoveSelections::CreateFromParamsArray.with(create_params)

    # TODO: we can do better than this
    # We need to determine if both players have submitted their selections so
    # that we can process the match turn and update their clients
    match = Match.last # TODO: this certainly won't hold up
    available_combatants = match.combatants.available.all

    if available_combatants.empty?
      match_turn = match.turn
      MatchMoveTurns::QueueFromMoveSelections.for(match_turn: match_turn)
      MatchTurns::Process.for(match_turn: match_turn)
      Matches::Arbitrate.for(match)
      MatchesChannel.broadcast_match(match)
    else
      Rails.logger.debug("#{available_combatants.size} combatants not queued")
    end
  end

  private

  # @return [ActionController::Parameters]
  def create_params
    # @param param [ActionController::Parameters]
    params.require(:match_move_selections).map do |param|
      param.permit(:board_position_id, :match_combatants_move_id)
    end
  end
end
