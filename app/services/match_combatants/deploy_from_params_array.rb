# frozen_string_literal: true

module MatchCombatants
  class DeployFromParamsArray < ApplicationService
    def initialize(params_array)
      @params_array = params_array
    end

    def perform
      params_array.each do |params|
        MatchCombatants::DeployFromParams.with(params)
      end
    end

    private

    attr_reader :params_array
  end
end
