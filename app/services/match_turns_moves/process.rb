# frozen_string_literal: true

module MatchTurnsMoves
  # Calculate and apply the outcomes resultant from this [MatchTurnsMove]'s
  # [Move]'s [MoveEffect]s
  class Process < ApplicationService
    ACTIONS_MAP = {
      damage: MoveEffects::ProcessDamage,
      relocation: Matches::ProcessRelocation,
      status_effect_chance: Matches::ProcessStatusEffectChance
    }.freeze

    def initialize(match_turns_move:)
      @match_turns_move = match_turns_move
    end

    def perform
      ActiveRecord::Base.transaction do
        if match_combatant.remaining_energy >= move.energy_cost
          adjust_combatant_energy
          process_move_effects
        end
        match_turns_move.update!(processed_at: Time.now.utc)
        MatchCombatants::UpdateAvailability.for(match_combatant)
      end
    end

    private

    attr_reader :match_turns_move

    def adjust_combatant_energy
      MatchCombatants::AdjustRemainingEnergy.for(
        match_combatant: match_combatant,
        move: move
      )
    end

    def board_position
      match_turns_move.board_position
    end

    def match_combatant
      match_turns_move.match_combatant
    end

    def match_turn
      match_turns_move.match_turn
    end

    def move
      match_turns_move.move
    end

    def move_effects
      move.effects.all
    end

    def process_move_effects
      move_effects.map do |move_effect|
        action_key = move_effect.category.to_sym
        if (service = ACTIONS_MAP[action_key])
          process_move_effect(move_effect: move_effect,
                              service: service)
        end
      end
    end

    def process_move_effect(move_effect:, service:)
      service.for(
        board_position: board_position,
        match_combatant: match_combatant,
        match_turns_move: match_turns_move,
        move_effect: move_effect
      )
    end
  end
end
