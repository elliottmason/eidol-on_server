# frozen_string_literal: true

module MatchMoveSelections
  class CreateFromParamsArray < ApplicationService
    def initialize(params_array)
      @params_array = params_array
    end

    def perform
      params_array.each do |params|
        params_hash = params.to_hash.symbolize_keys
        MatchMoveSelections::CreateFromParams.with(**params_hash)
      end
    end

    private

    attr_reader :params_array
  end
end
