# frozen_string_literal: true

class MatchMoveSelectionsController < ApplicationController
  def create
    MatchMoveSelections::CreateFromParamsArray.with(create_params)

    # TODO: we can do better than this
    # We need to determine if both players have submitted their selections so
    # that we can process the match turn and update their clients
    match = Match.last # TODO: this certainly won't hold up
    available_combatants = match.combatants.available.all.to_a
    selected_combatants =
      MatchMoveSelection.where(match_turn: match.turn).all.map(&:match_combatant)
    remaining_combatants = available_combatants.clone - selected_combatants

    if remaining_combatants.size.zero?
      MatchMoveTurns::QueueFromMoveSelections.for(match_turn: match.turn)
      MatchTurns::Process.for(match_turn: match.turn)
      MatchesChannel.broadcast_match(match)
    else
      Rails.logger.debug("#{remaining_combatants.size} combatants not queued")
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
