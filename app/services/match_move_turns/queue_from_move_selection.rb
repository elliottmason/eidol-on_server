# frozen_string_literal: true

module MatchMoveTurns
  class QueueFromMoveSelection < ApplicationService
    # @param match_move_selection [MatchMoveSelection]
    # @param match_turn [MatchTurn]
    def initialize(
      match_move_selection:,
      match_turn:
    )
      @match_move_selection = match_move_selection
      @match_turn = match_turn
    end

    def perform
      MatchMoveTurns::Queue.with(
        match_combatant: match_combatant,
        match_move_selection: match_move_selection,
        match_turn: match_turn,
        move: move
      )
    end

    private

    # @return [MatchMoveSelection]
    attr_reader :match_move_selection

    # @return [MatchTurn]
    attr_reader :match_turn

    # @return [MatchCombatant]
    def match_combatant
      match_move_selection.match_combatant
    end

    # @return [Move]
    def move
      match_move_selection.move
    end
  end
end
