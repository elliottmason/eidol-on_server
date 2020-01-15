# frozen_string_literal: true

module MatchTurnsMoves
  # Calculates the effective predecence of [MatchTurnsMove]s based on
  # [Move#speed] and [MatchCombatant#level]
  class CalculateSpeed < ApplicationService
    # @return [Integer, nil]
    attr_reader :value

    # @param match_turns_move [MatchTurnsMove]
    def initialize(match_turns_move)
      @match_turns_move = match_turns_move
    end

    # @return [Integer]
    def perform
      @value = move.speed * match_combatant.agility
    end

    private

    # @return [MatchTurnsMove]
    attr_reader :match_turns_move

    # @!method match_combatant()
    #   @return [MatchCombatant]
    delegate :match_combatant, to: :match_turns_move

    # @!method move()
    #   @return [Integer]
    delegate :move, to: :match_turns_move
  end
end
