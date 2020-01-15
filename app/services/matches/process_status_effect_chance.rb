# frozen_string_literal: true

module Matches
  class ProcessStatusEffectChance < ApplicationService
    # @param board_position [BoardPosition]
    # @param match_combatant [MatchCombatant]
    # @param match_turns_move [MatchTurnsMove]
    # @param move_effect [MoveEffect]
    def initialize(
      board_position:,
      match_combatant:,
      match_turns_move:,
      move_effect:
    )
      @board_position = board_position
      @match_turns_move = match_turns_move
      @move_effect = move_effect
      @source_combatant = match_combatant
    end

    def perform
      return unless rand(1..100) <= status_effect_chance
    end

    private

    # @return [MoveEffect]
    attr_reader :move_effect

    # @return [Integer]
    def status_effect_chance
      move_effect.power
    end
  end
end
