# frozen_string_literal: true

module MatchTurnsMoves
  class QueueFromMoveSelection < ApplicationService
    def initialize(
      match_move_selection:,
      match_turn:
    )
      @match_move_selection = match_move_selection
      @match_turn = match_turn
    end

    def perform
      MatchTurnsMoves::Queue.with(
        match_combatant: match_combatant,
        match_move_selection: match_move_selection,
        match_turn: match_turn,
        move: move
      )
    end

    private

    attr_reader :match_move_selection

    attr_reader :match_turn

    def match_combatant
      match_move_selection.match_combatant
    end

    def move
      match_move_selection.move
    end
  end
end
