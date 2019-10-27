# frozen_string_literal: true

module Matches
  # Update a [MatchCombatantStatus] with the new [BoardPosition] if it's
  # actually possivle for the [MatchCombatant] to move there from its current
  # position
  class ProcessRelocation < ApplicationService
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

    # @return [Boolean]
    def allowed?
      match_combatant_position = match_combatant.status.board_position
      x_coord = match_combatant_position.x
      y_coord = match_combatant_position.y
      move_range = move_turn_effect.move_turn.move.range
      x_range = (x_coord - move_range)..(x_coord + move_range)
      y_range = (y_coord - move_range)..(y_coord + move_range)

      available_board_position =
        BoardPosition \
        .for_match(match) \
        .where(id: board_position.id, x: x_range, y: y_range) \
        .first

      match_combatant.queued? &&
        available_board_position&.occupants&.empty?
    end

    # @return [MatchEvent]
    def perform
      @successful = false
      ActiveRecord::Base.transaction do
        create_match_event
        MatchCombatants::Relocate.with(
          board_position: board_position,
          match_combatant: match_combatant,
          match_event: match_event
        )
        @successful = true
      end
    end

    # @return [nil]
    def after_failure
      Rails.logger.debug(' --- FAILED --- ')
      create_match_event('failed')
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

    # @param status [String]
    # @return [MatchEvent]
    def create_match_event(status = 'successful')
      @match_event =
        MatchEvent.create!(
          board_position: board_position,
          match_combatant: match_combatant,
          match_move_turn: match_move_turn,
          move_turn_effect: move_turn_effect,
          category: 'relocation',
          property: 'normal',
          status: status
        )
    end

    # @return [Match]
    def match
      @match ||= board_position.match
    end
  end
end
