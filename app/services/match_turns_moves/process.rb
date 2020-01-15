# frozen_string_literal: true

module MatchTurnsMoves
  # Calculate and apply the outcomes resultant from this [MatchTurnsMove]'s
  # [Move]'s [MoveEffect]s
  class Process < ApplicationService
    # @type [Hash<Symbol: ApplicationService>]
    ACTIONS_MAP = {
      damage: MoveEffects::ProcessDamage,
      relocation: Matches::ProcessRelocation,
      status_effect_chance: Matches::ProcessStatusEffectChance
    }.freeze

    # @param match_turns_move [MatchTurnsMove]
    def initialize(match_turns_move:)
      @match_turns_move = match_turns_move
    end

    # @return [Array<MatchEvent>]
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

    # @return [MatchTurnsMove]
    attr_reader :match_turns_move

    # @return [void]
    def adjust_combatant_energy
      MatchCombatants::AdjustRemainingEnergy.for(
        match_combatant: match_combatant,
        move: move
      )
    end

    # @return [BoardPosition]
    def board_position
      match_turns_move.board_position
    end

    # @return [MatchCombatant]
    def match_combatant
      match_turns_move.match_combatant
    end

    # @return [MatchTurn]
    def match_turn
      match_turns_move.match_turn
    end

    # @return [Move]
    def move
      match_turns_move.move
    end

    # @return [Array<MoveEffect>]
    def move_effects
      move.effects.all
    end

    # @return [void]
    def process_move_effects
      # @param move_effect [MoveEffect]
      move_effects.map do |move_effect|
        # @type [Symbol]
        action_key = move_effect.category.to_sym
        # @type [ApplicationService, nil]
        if (service = ACTIONS_MAP[action_key])
          process_move_effect(move_effect: move_effect,
                              service: service)
        end
      end
    end

    # @param move_effect [MoveEffect]
    # @param service [ApplicationService]
    # @return [ApplicationService]
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
