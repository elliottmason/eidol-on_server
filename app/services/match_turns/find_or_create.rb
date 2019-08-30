# frozen_string_literal: true

module MatchTurns
  class FindOrCreate < ApplicationService
    # @return [MatchTurn, nil]
    attr_reader :match_turn

    # @param match [Match]
    # @param move_turn [MoveTurn]
    def initialize(match:, move_turn:)
      @match = match
      @move_turn = move_turn
    end

    # @return [MatchTurn]
    def perform
      @match_turn =
        MatchTurn.where(match: match, turn: turn_offset).first_or_create!
    end

    private

    # @return [Match]
    attr_reader :match

    # @return [MoveTurn]
    attr_reader :move_turn

    # @return [Integer]
    def turn_offset
      match.current_turn.turn + move_turn.turn - 1
    end
  end
end
