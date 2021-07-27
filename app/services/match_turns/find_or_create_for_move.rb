# frozen_string_literal: true

module MatchTurns
  class FindOrCreateForMove < ApplicationService
    attr_reader :match_turn

    def initialize(match:, move:)
      @match = match
      @move = move
    end

    def perform
      @match_turn =
        MatchTurn.where(match: match, turn: turn_number).first_or_create!
    end

    private

    attr_reader :match

    attr_reader :move

    def turn_number
      match.turn.turn + 1
    end
  end
end
