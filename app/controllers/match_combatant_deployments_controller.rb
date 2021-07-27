# frozen_string_literal: true

class MatchCombatantDeploymentsController < ApplicationController
  def create
    MatchCombatants::DeployFromParamsArray.with(create_params)

    # TODO: we can do better than this
    # We need to determine if both players have submitted their deployments so
    # that we can update the clients with the new positions

    match = Match.last # TODO: this is non-logic
    deployed_combatants = MatchCombatant.where(match: match).deployed.all
    available_combatants = MatchCombatant.where(match: match).available.all

    if deployed_combatants.size == 4 ||
      deployed_combatants.size == available_combatants.size
      Matches::AdvanceTurn.for(match: match)
      MatchesChannel.broadcast_match(match)
    end
  end

  def create_params
    params.require(:match_combatant_deployments).map do |param|
      param.permit(:board_position_id, :match_combatant_id)
    end
  end
end
