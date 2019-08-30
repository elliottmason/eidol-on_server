# frozen_string_literal: true

module MatchTurnsMoveTurns
  # Calculates the effective predecence of [MatchTurnsMoveTurn]s based on
  # [MoveTurn#speed] and [CombatantsPlayersMatch#level]
  class CalculateSpeed < ApplicationService
    # @param match_turns_move_turn [MatchTurnsMoveTurn]
    def initialize(match_turns_move_turn)
      @match_turns_move_turn = match_turns_move_turn
    end

    # @return [Integer]
    def perform
      match_turns_move_turn.move_turn.speed +
        match_turns_move_turn.combatants_players_match.level
    end

    private

    # @return [MatchTurnsMoveTurn]
    attr_reader :match_turns_move_turn
  end
end
