# frozen_string_literal: true

module Matches
  # Update a [MatchCombatantStatus] with the new [BoardPosition] if it's
  # actually possivle for the [MatchCombatant] to move there from its current
  # position
  class ProcessRelocation < ApplicationService
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
      @match_combatant = match_combatant
      @match_turns_move = match_turns_move
      @move_effect = move_effect
    end

    # @return [Boolean]
    def allowed?
      match_combatant_position = match_combatant.status.board_position
      x_coord = match_combatant_position.x
      y_coord = match_combatant_position.y
      # @type [Integer]
      move_range = move_effect.move.range
      x_range = (x_coord - move_range)..(x_coord + move_range)
      y_range = (y_coord - move_range)..(y_coord + move_range)

      # @type [BoardPosition]
      available_board_position =
        BoardPosition \
        .for_match(match) \
        .find_by(id: board_position.id, x: x_range, y: y_range)

      return false unless available_board_position

      match_combatant.queued? && available_board_position.occupants.empty?
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

    # @return [void]
    def after_failure
      create_match_event('failed')
    end

    private

    # @return [BoardPosition]
    attr_reader :board_position

    # @return [MatchCombatant]
    attr_reader :match_combatant

    # @return [MatchEvent]
    attr_reader :match_event

    # @return [MatchTurnsMove]
    attr_reader :match_turns_move

    # @return [MoveEffect]
    attr_reader :move_effect

    # @param status [String]
    # @return [MatchEvent]
    def create_match_event(status = 'successful')
      @match_event =
        MatchEvent.create!(
          board_position: board_position,
          match_combatant: match_combatant,
          match_turns_move: match_turns_move,
          move_effect: move_effect,
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
