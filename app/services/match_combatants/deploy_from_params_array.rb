# frozen_string_literal: true

module MatchCombatants
  class DeployFromParamsArray < ApplicationService
    # @param params_array [Array<ActionController::Parameters>]
    def initialize(params_array)
      @params_array = params_array
    end

    def perform
      # @param params [ActionController::Parameters]
      params_array.each do |params|
        MatchCombatants::DeployFromParams.with(params)
      end
    end

    private

    # @return [Array<ActionController::Parameters>]
    attr_reader :params_array
  end
end
