# frozen_string_literal: true

module MatchMoveSelections
  # Create a [MatchMoveSelection] record and queue up the [MatchTurnsMove]s from
  # the associated [Move]
  class Create < ApplicationService
    def initialize(
      board_position: nil,
      match_combatants_move:
    )
      @board_position = board_position
      @match_combatants_move = match_combatants_move
    end

    def allowed?
      board_position.is_a?(BoardPosition) &&
        match_combatants_move.is_a?(MatchCombatantsMove)
    end

    def perform
      ActiveRecord::Base.transaction do
        create_selection
        MatchTurnsMoves::QueueFromMoveSelection.for(
          match_move_selection: match_move_selection,
          match_turn: match_turn
        )
        MatchCombatants::UpdateAvailability.for(match_combatant)
        MatchTurns::ConditionallyProcess.for(match_turn: match_turn)
      end
    end

    private

    attr_reader :board_position

    def create_selection
      @match_move_selection =
        MatchMoveSelection.create!(
          board_position: board_position,
          match_combatants_move: match_combatants_move,
          match_turn: match_turn,
          was_system_selected: was_system_selected?
        )
    end

    def match
      @match ||= match_combatants_move.match
    end

    def match_combatant
      @match_combatant ||= match_combatants_move.match_combatant
    end

    attr_reader :match_combatants_move

    attr_reader :match_move_selection

    def match_turn
      @match_turn ||= match.turn
    end

    attr_reader :player

    def was_system_selected?
      player.blank?
    end
  end
end
