# frozen_string_literal: true

class MatchCombatantDeploymentsController < ApplicationController
  def create
    MatchCombatants::DeployFromParamsArray.with(create_params)
  end

  # @return [ActionController::Parameters]
  def create_params
    params.require(:match_combatant_deployments).map do |p|
      p.permit(:board_position_id, :match_combatant_id)
    end
  end
end
