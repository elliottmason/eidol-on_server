# frozen_string_literal: true

module MatchMoveTurns
  # Iterate through the given [MatchTurn]'s [MatchMoveSelection]s
  # so we can potentially queue up [MatchMoveTurn]s for each one
  class QueueFromMoveSelections < ApplicationService
    # @param match_turn [MatchTurn]
    def initialize(match_turn:)
      @match_turn = match_turn
    end

    def perform
      match_move_selections.each do |match_move_selection|
        MatchMoveTurns::QueueFromMoveSelection.with(
          match_move_selection: match_move_selection,
          match_turn: match_turn
        )
      end
    end

    private

    # @return [MatchTurn]
    attr_reader :match_turn

    # @return [ActiveRecord::Relation<MatchMoveSelection>]
    def match_move_selections
      MatchMoveSelection.where(match_turn: match_turn).all
    end
  end
end
