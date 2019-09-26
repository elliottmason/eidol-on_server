# frozen_string_literal: true

class MatchMoveSelectionsController < ApplicationController
  def create
    MatchMoveSelections::CreateFromParamsArray.with(
      create_params[:match_move_selections]
    )

    # TODO: we can do better than this
    match = Match.last
    available_combatants = MatchCombatant.where(match: match).available.all.to_a
    selected_combatants =
      MatchMoveSelection.where(match_turn: match.turn).all.map(&:match_combatant)
    remaining_combatants = available_combatants.clone - selected_combatants

    if remaining_combatants.size.zero?
      MatchMoveTurns::QueueFromMoveSelections.for(match_turn: match.turn)
      MatchTurns::Process.for(match_turn: match.turn)
    else
      Rails.logger.debug("#{remaining_combatants.size} combatants not queued")
    end
  end

  private

  def create_params
    params.permit(
      match_move_selections: %i[board_position_id match_combatants_move_id]
    )
  end
end
