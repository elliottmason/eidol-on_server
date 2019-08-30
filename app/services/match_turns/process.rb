# frozen_string_literal: true

module MatchTurns
  # Sort and consecutively handle each MoveTurn associated with this MatchTurn
  class Process < ApplicationService
    # collect unprocessed move turns for this match turn
    # order move selections by precedence
    # process the first move selection in the list
    #   determine the effects of the selected move
    #   store the effects of the move
    #   apply the effects of the move
    #   mark the move selection as processed
    # loop
    # advance match turn by 1

    # @param match_turn [MatchTurn]
    def initialize(match_turn:)
      @match_turn = match_turn
    end

    # @return [Array<MatchTurnsMoveTurnsMoveTurnEffect>]
    def match_turns_move_turns_move_turn_effect
      @match_turns_move_turns_move_turn_effect ||= []
    end

    # @return [void]
    def perform
      ActiveRecord::Base.transaction do
        while unprocessed_match_turns_move_turns.size.nonzero?
          match_turns_move_turns_move_turn_effect <<
            MatchTurnsMoveTurns::Process.for(
              match_turns_move_turn: next_unprocessed_match_turns_move_turn
            )
        end
      end
    end

    private

    # @return [MatchTurn]
    attr_reader :match_turn

    # @return [Array<MatchTurnsMoveTurn>]
    def sorted_unprocessed_match_turns_move_turns
      unprocessed_match_turns_move_turns.sort do |turn_a, turn_b|
        MatchTurnsMoveTurns::CalculateSpeed.for(turn_a).value <=>
          MatchTurnsMoveTurns::CalculateSpeed.for(turn_b).value
      end
    end

    # @return [MatchTurnsMoveTurn]
    def next_unprocessed_match_turns_move_turn
      sorted_unprocessed_match_turns_move_turns.first
    end

    # @return [Array<MatchTurnsMoveTurn>]
    def unprocessed_match_turns_move_turns
      MatchTurnsMoveTurn.where(match_turn: match_turn, processed_at: nil).all
    end
  end
end
