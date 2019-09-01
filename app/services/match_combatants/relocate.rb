# frozen_string_literal: true

module MatchCombatants
  class Relocate < ApplicationService
    # @param board_position [BoardPosition]
    # @param match_combatant [MatchCombatant]
    # @param match_turn [MatchTurn]
    # @param match_move_turn [MatchMoveTurn]
    # @param move_turn_effect [MoveTurnEffect]
    def initialize(
      board_position:,
      match_combatant:,
      match_turn:,
      match_move_turn:,
      move_turn_effect:
    )
      @board_position = board_position
      @match_combatant = match_combatant
      @match_turn = match_turn
      @match_move_turn = match_move_turn
      @move_turn_effect = move_turn_effect
    end

    # return [MatchEvent]
    def perform
      ActiveRecord::Base.transaction do
        create_match_event
        create_board_positions_match_combatant
      end
    end

    private

    # @return [BoardPosition]
    attr_reader :board_position

    # @return [MatchCombatant]
    attr_reader :match_combatant

    # @return [MatchTurn]
    attr_reader :match_turn

    # @return [MatchMoveTurn]
    attr_reader :match_move_turn

    # @return [MoveTurnEffect]
    attr_reader :move_turn_effect

    # @return [BoardPositionsMatchCombatant]
    def create_board_positions_match_combatant
      BoardPositionsMatchCombatant.create!(
        board_position: board_position,
        match_combatant: match_combatant
      )
    end

    # @return [MatchEvent]
    def create_match_event
      MatchEvent.create!(
        board_position: board_position,
        match_combatant: match_combatant,
        match_move_turn: match_move_turn,
        move_turn_effect: move_turn_effect,
        effect_type: 'relocation_normal',
        status: 'successful'
      )
    end
  end
end
