# frozen_string_literal: true

module Matches
  class ProcessStatusEffectChance < ApplicationService
    # @param board_position [BoardPosition]
    # @param match_combatant [MatchCombatant]
    # @param match_move_turn [MatchMoveTurn]
    # @param move_turn_effect [MoveTurnEffect]
    def initialize(
      board_position:,
      match_combatant:,
      match_move_turn:,
      move_turn_effect:
    )
      @board_position = board_position
      @match_move_turn = match_move_turn
      @move_turn_effect = move_turn_effect
      @source_combatant = match_combatant
    end

    def perform
      return unless rand(1..100) <= status_effect_chance
    end

    private

    # @return [MoveTurnEffect]
    attr_reader :move_turn_effect

    # @return [Integer]
    def status_effect_chance
      move_turn_effect.power
    end
  end
end
