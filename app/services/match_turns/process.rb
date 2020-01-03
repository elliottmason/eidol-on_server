# frozen_string_literal: true

module MatchTurns
  # Queue the [MatchMoveTurn[s based on this [MatchTurn]'s [MatchMoveSelection]s
  # Sort and consecutively handle each [MatchMoveTurn]
  class Process < ApplicationService
    # @param match_turn [MatchTurn]
    def initialize(match_turn:)
      @match_turn = match_turn
    end

    def allowed?
      match_turn.unprocessed?
    end

    # @return [void]
    def perform
      ActiveRecord::Base.transaction do
        while unprocessed_match_move_turns.size.nonzero?
          MatchMoveTurns::Process.for(
            match_move_turn: next_unprocessed_match_move_turn
          )
        end

        next_match_turn = Matches::AdvanceTurn.for(match: match).match_turn
        MatchTurns::ConditionallyProcess.with(match_turn: next_match_turn)
      end
    end

    private

    # @return [MatchTurn]
    attr_reader :match_turn

    # @return [Match]
    def match
      match_turn.match
    end

    # We have to sort the turns each time because the outcome of the previous
    # turn might change the precedence of the remaining turns, e.g. an effect
    # that lowers a combatant's agility
    # @return [Array<MatchMoveTurn>]
    def sorted_unprocessed_match_move_turns
      unprocessed_match_move_turns.sort do |turn_a, turn_b|
        turn_a_speed = MatchMoveTurns::CalculateSpeed.for(turn_a).value
        turn_b_speed = MatchMoveTurns::CalculateSpeed.for(turn_b).value

        # @type [Integer]
        result = turn_b_speed <=> turn_a_speed

        # perform a coin toss if speeds are identical
        next result unless result.zero?

        [-1, 1].sample
      end
    end

    # @return [MatchMoveTurn]
    def next_unprocessed_match_move_turn
      sorted_unprocessed_match_move_turns.first
    end

    # @return [Array<MatchMoveTurn>]
    def unprocessed_match_move_turns
      MatchMoveTurn.unprocessed.where(match_turn: match_turn).all
    end
  end
end
