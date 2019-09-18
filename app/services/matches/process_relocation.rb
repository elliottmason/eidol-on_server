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
      true
    end

    # @return [MatchEvent]
    def perform
      ActiveRecord::Base.transaction do
        create_match_event
        MatchCombatants::Relocate.with(
          board_position: board_position,
          match_combatant: match_combatant,
          match_event: match_event
        )
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

    # @return [MatchEvent]
    def create_match_event
      @match_event =
        MatchEvent.create!(
          board_position: board_position,
          match_combatant: match_combatant,
          match_move_turn: match_move_turn,
          move_turn_effect: move_turn_effect,
          category: 'relocation',
          property: 'normal',
          status: 'successful'
        )
    end
  end
end
