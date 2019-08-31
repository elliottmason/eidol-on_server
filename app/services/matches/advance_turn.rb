# frozen_string_literal: true

module Matches
  class AdvanceTurn < ApplicationService
    # @param match [Match]
    def initialize(match:)
      @match = match
    end

    def perform
      ActiveRecord::Base.transaction do
        current_match_turn.update!(processed_at: Time.now.utc)
        MatchTurn.where(match: match, turn: next_turn_number).first_or_create!
      end
    end

    private

    # @return [Match]
    attr_reader :match

    # @return [MatchTurn]
    def current_match_turn
      match.current_turn
    end

    # @return [Integer]
    def next_turn_number
      @next_turn_number ||= current_match_turn.turn + 1
    end
  end
end
