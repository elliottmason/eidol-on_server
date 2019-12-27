# frozen_string_literal: true

module MatchMoveTurns
  # Calculate and apply the outcomes resultant from this [MatchMoveTurn]'s
  # [MoveTurn]'s [MoveTurnEffect]s
  class Process < ApplicationService
    # @type [Hash<Symbol: ApplicationService>]
    ACTIONS_MAP = {
      damage: MoveTurnEffects::ProcessDamage,
      relocation: Matches::ProcessRelocation,
      status_effect_chance: Matches::ProcessStatusEffectChance
    }.freeze

    # @param match_move_turn [MatchMoveTurn]
    def initialize(match_move_turn:)
      @match_move_turn = match_move_turn
    end

    # @return [Array<MatchEvent>]
    def perform
      ActiveRecord::Base.transaction do
        if match_combatant.remaining_energy >= move.energy_cost
          adjust_combatant_energy
          process_move_turn_effects
        end
        match_move_turn.update!(processed_at: Time.now.utc)
        MatchCombatants::UpdateAvailability.for(match_combatant)
      end
    end

    private

    # @return [MatchMoveTurn]
    attr_reader :match_move_turn

    # @return [void]
    def adjust_combatant_energy
      MatchCombatants::AdjustRemainingEnergy.for(
        match_combatant: match_combatant,
        move: move
      )
    end

    # @return [BoardPosition]
    def board_position
      match_move_turn.board_position
    end

    # @return [MatchCombatant]
    def match_combatant
      match_move_turn.match_combatant
    end

    # @return [MatchTurn]
    def match_turn
      match_move_turn.match_turn
    end

    # @return [Move]
    def move
      move_turn.move
    end

    # @return [Array<MoveTurnEffect>]
    def move_turn_effects
      move_turn.effects.all
    end

    # @return [MoveTurn]
    def move_turn
      match_move_turn.move_turn
    end

    # @return [void]
    def process_move_turn_effects
      # @param move_turn_effect [MoveTurnEffect]
      move_turn_effects.map do |move_turn_effect|
        # @type [Symbol]
        action_key = move_turn_effect.category.to_sym
        # @type [ApplicationService, nil]
        if (service = ACTIONS_MAP[action_key])
          process_move_turn_effect(move_turn_effect: move_turn_effect,
                                   service: service)
        end
      end
    end

    # @param move_turn_effect [MoveTurnEffect]
    # @param service [ApplicationService]
    # @return [ApplicationService]
    def process_move_turn_effect(move_turn_effect:, service:)
      service.for(
        board_position: board_position,
        match_combatant: match_combatant,
        match_move_turn: match_move_turn,
        move_turn_effect: move_turn_effect
      )
    end
  end
end
