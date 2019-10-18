# frozen_string_literal: true

module MatchMoveSelections
  # Create a [MatchMoveSelection] record and queue up the [MatchMoveTurn]s from
  # the associated [Move]
  class Create < ApplicationService
    # @param board_position [BoardPosition, NilClass]
    # @param match_combatants_move [MatchCombatantsMove]
    def initialize(
      board_position: nil,
      match_combatants_move:
    )
      @board_position = board_position
      @match_combatants_move = match_combatants_move
    end

    # @return [Boolean]
    def allowed?
      board_position.is_a?(BoardPosition) &&
        match_combatants_move.is_a?(MatchCombatantsMove)
    end

    # @return [MatchMoveSelection]
    def perform
      MatchMoveSelection.create!(
        board_position: board_position,
        match_combatants_move: match_combatants_move,
        was_system_selected: was_system_selected?
      )
    end

    private

    # @return [BoardPosition, NilClass]
    attr_reader :board_position

    # @return [MatchCombatantsMove]
    attr_reader :match_combatants_move

    # @return [Player, NilClass]
    attr_reader :player

    # @return [Match]
    def match
      @match ||= match_combatants_move.match
    end

    # @return [MatchTurn]
    def match_turn
      @match_turn ||= match.turn
    end

    def was_system_selected?
      player.blank?
    end
  end
end
