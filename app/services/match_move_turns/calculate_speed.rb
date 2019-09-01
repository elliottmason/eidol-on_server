# frozen_string_literal: true

module MatchMoveTurns
  # Calculates the effective predecence of [MatchMoveTurn]s based on
  # [MoveTurn#speed] and [MatchCombatant#level]
  class CalculateSpeed < ApplicationService
    # @return [Integer, nil]
    attr_reader :value

    # @param match_move_turn [MatchMoveTurn]
    def initialize(match_move_turn)
      @match_move_turn = match_move_turn
    end

    # @return [Integer]
    def perform
      @value =
        match_move_turn.move_turn.speed +
        match_move_turn.match_combatant.level
    end

    private

    # @return [MatchMoveTurn]
    attr_reader :match_move_turn
  end
end
