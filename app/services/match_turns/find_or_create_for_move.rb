# frozen_string_literal: true

module MatchTurns
  class FindOrCreateForMove < ApplicationService
    # @return [MatchTurn, nil]
    attr_reader :match_turn

    # @param match [Match]
    # @param move [Move]
    def initialize(match:, move:)
      @match = match
      @move = move
    end

    # @return [MatchTurn]
    def perform
      @match_turn =
        MatchTurn.where(match: match, turn: turn_number).first_or_create!
    end

    private

    # @return [Match]
    attr_reader :match

    # @return [Move]
    attr_reader :move

    # @return [Integer]
    def turn_number
      match.turn.turn + 1
    end
  end
end
