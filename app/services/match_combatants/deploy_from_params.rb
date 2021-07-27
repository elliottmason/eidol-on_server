# frozen_string_literal: true

module MatchCombatants
  class DeployFromParams < ApplicationService
    def initialize(params)
      @params = params
    end

    def perform
      MatchCombatants::Deploy.with(
        board_position: board_position,
        match_combatant: match_combatant
      )
    end

    private

    attr_reader :params

    def board_position
      @board_position ||= BoardPosition.find(params[:board_position_id])
    end

    def match_combatant
      @match_combatant = MatchCombatant.find(params[:match_combatant_id])
    end
  end
end
