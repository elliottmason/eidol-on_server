# frozen_string_literal: true

module Matches
  class AdvanceTurn < ApplicationService
    attr_reader :match_turn

    def initialize(match:)
      @match = match
    end

    def perform
      ActiveRecord::Base.transaction do
        @match_turn =
          MatchTurn.where(match: match, turn: next_turn_number).first_or_create!
        current_turn.update!(processed_at: Time.now.utc)
      end
    end

    private

    attr_reader :match

    def current_turn
      match.turn
    end

    def next_turn_number
      current_turn.turn + 1
    end
  end
end
