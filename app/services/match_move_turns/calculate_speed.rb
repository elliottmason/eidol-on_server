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
      @value = move_turn.speed * match_combatant.agility
    end

    private

    # @return [MatchMoveTurn]
    attr_reader :match_move_turn

    # @!method match_combatant()
    #   @return [MatchCombatant]
    delegate :match_combatant, to: :match_move_turn

    # @!method move_turn()
    #   @return [Integer]
    delegate :move_turn, to: :match_move_turn
  end
end
