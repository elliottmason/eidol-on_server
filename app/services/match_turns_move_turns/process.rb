# frozen_string_literal: true

module MatchTurnsMoveTurns
  class Process < ApplicationService
    # @type [Hash<Symbol: ApplicationService>]
    ACTIONS_MAP = {
      relocation_normal: CombatantsPlayersMatches::Relocate
    }.freeze

    # @param match_turns_move_turn [MatchTurnsMoveTurn]
    def initialize(match_turns_move_turn:)
      @match_turns_move_turn = match_turns_move_turn
    end

    # @return [Array<MatchTurnsMoveTurnsMoveTurnEffect>]
    def perform
      ActiveRecord::Base.transaction do
        process_move_turn_effects
        match_turns_move_turn.update!(processed_at: Time.now.utc)
      end
    end

    private

    # @return [MatchTurnsMoveTurn]
    attr_reader :match_turns_move_turn

    # @return [BoardPosition]
    def board_position
      match_turns_move_turn.board_position
    end

    # @return [CombatantsPlayersMatch]
    def combatants_players_match
      match_turns_move_turn.combatants_players_match
    end

    # @return [MatchTurn]
    def match_turn
      match_turns_move_turn.match_turn
    end

    # @return [Array<MoveTurnEffect>]
    def move_turn_effects
      move_turn.effects.all
    end

    # @return [MoveTurn]
    def move_turn
      match_turns_move_turn.move_turn
    end

    # @return [void]
    def process_move_turn_effects
      # @param move_turn_effect [MoveTurnEffect]
      move_turn_effects.map do |move_turn_effect|
        # @type [Symbol]
        action_key = move_turn_effect.effect_type.to_sym
        # @type [ApplicationService]
        service = ACTIONS_MAP[action_key]
        process_move_turn_effect(move_turn_effect: move_turn_effect,
                                 service: service)
      end
    end

    # @param move_turn_effect [MoveTurnEffect]
    # @param service [ApplicationService]
    # @return [ApplicationService]
    def process_move_turn_effect(move_turn_effect:, service:)
      service.for(
        board_position: board_position,
        combatants_players_match: combatants_players_match,
        match_turn: match_turn,
        match_turns_move_turn: match_turns_move_turn,
        move_turn_effect: move_turn_effect
      )
    end
  end
end
