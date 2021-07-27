# frozen_string_literal: true

module MatchTurnsMoves
  # Calculates the effective predecence of [MatchTurnsMove]s based on
  # [Move#speed] and [MatchCombatant#level]
  class CalculateSpeed < ApplicationService
    attr_reader :value

    def initialize(match_turns_move)
      @match_turns_move = match_turns_move
    end

    def perform
      @value = move.speed * match_combatant.agility
    end

    private

    attr_reader :match_turns_move

    delegate :match_combatant, to: :match_turns_move

    delegate :move, to: :match_turns_move
  end
end
