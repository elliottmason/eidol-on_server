# frozen_string_literal: true

module Matches
  class ProcessStatusEffectChance < ApplicationService
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

    attr_reader :move_effect

    def status_effect_chance
      move_effect.power
    end
  end
end
