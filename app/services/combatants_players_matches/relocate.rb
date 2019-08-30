# frozen_string_literal: true

module CombatantsPlayersMatches
  class Relocate < ApplicationService
    # @param board_position [BoardPosition]
    # @param combatants_players_match [CombatantsPlayersMatch]
    # @param match_turn [MatchTurn]
    # @param match_turns_move_turn [MatchTurnsMoveTurn]
    # @param move_turn_effect [MoveTurnEffect]
    def initialize(
      board_position:,
      combatants_players_match:,
      match_turn:,
      match_turns_move_turn:,
      move_turn_effect:
    )
      @board_position = board_position
      @combatants_players_match = combatants_players_match
      @match_turn = match_turn
      @match_turns_move_turn = match_turns_move_turn
      @move_turn_effect = move_turn_effect
    end

    # return [MatchEvent]
    def perform
      ActiveRecord::Base.transaction do
        create_match_turns_move_turn_move_turn_effect
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

    # @return [MatchTurnsMoveTurn]
    attr_reader :match_turns_move_turn

    # @return [MoveTurnEffect]
    attr_reader :move_turn_effect

    # @return [CombatantsPlayersMatchesMatchTurn]
    def create_combatants_players_matches_match_turn
      BoardPositionsCombatantsPlayersMatch.create!(
        board_position: board_position,
        combatants_players_match: combatants_players_match,
        match_turn: match_turn
      )
    end

    # @return [MatchTurnsMoveTurnsMoveTurnEffect]
    def create_match_turns_move_turn_move_turn_effect
      MatchTurnsMoveTurnsMoveTurnEffect.create!(
        board_position: board_position,
        combatants_players_match: combatants_players_match,
        match_turns_move_turn: match_turns_move_turn,
        move_turn_effect: move_turn_effect,
        effect_type: 'relocation_normal',
        status: 'successful'
      )
    end
  end
end
