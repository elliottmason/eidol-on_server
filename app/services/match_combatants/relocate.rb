# frozen_string_literal: true

module MatchCombatants
  class Relocate < ApplicationService
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
      @match_combatant = match_combatant
      @match_move_turn = match_move_turn
      @move_turn_effect = move_turn_effect
    end

    # return [MatchEvent]
    def perform
      ActiveRecord::Base.transaction do
        create_match_event
        update_match_combatant_status
      end
    end

    private

    # @return [BoardPosition]
    attr_reader :board_position

    # @return [MatchCombatant]
    attr_reader :match_combatant

    # @return [MatchEvent]
    attr_reader :match_event

    # @return [MatchMoveTurn]
    attr_reader :match_move_turn

    # @return [MoveTurnEffect]
    attr_reader :move_turn_effect

    # @return [MatchCombatantStatus]
    def update_match_combatant_status
      new_status = match_combatant.status.dup
      new_status.board_position = board_position
      new_status.match_event = match_event
      new_status.save!
    end

    # @return [MatchEvent]
    def create_match_event
      @match_event =
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
