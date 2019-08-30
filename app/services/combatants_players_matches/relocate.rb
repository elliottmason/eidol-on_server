# frozen_string_literal: true

module CombatantsPlayersMatches
  class Relocate < ApplicationService
    # @param board_position [BoardPosition]
    # @param combatants_players_match [CombatantsPlayersMatch]
    # @param match_turn [MatchTurn]
    def initialize(board_position:, combatants_players_match:, match_turn:)
      @board_position = board_position
      @combatants_players_match = combatants_players_match
      @match_turn = match_turn
    end

    # return [MatchEvent]
    def perform
      ActiveRecord::Base.transaction do
        create_match_turn_event
        create_combatants_players_matches_match_turn
      end
    end

    private

    # @return [BoardPosition]
    attr_reader :board_position

    # @return [CombatantsPlayersMatch]
    attr_reader :combatants_players_match

    # @return [MatchTurn]
    attr_reader :match_turn

    # @return [CombatantsPlayersMatchesMatchTurn]
    def create_combatants_players_matches_match_turn
      BoardPositionsCombatantsPlayersMatch.create!(
        board_position: board_position,
        combatants_players_match: combatants_players_match,
        match_turn: match_turn
      )
    end

    # @return [MatchTurnEvent]
    def create_match_turn_event
      MatchTurnEvent.create!(
        match_turn: match_turn
      )
    end
  end
end
