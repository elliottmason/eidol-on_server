# frozen_string_literal: true

module MatchTurnsMoveTurns
  class Process < ApplicationServer
    # @param match_turns_move_turn [MatchTurnsMoveTurn]
    def initialize(match_turns_move_turn:)
      @match_turns_move_turn = match_turns_move_turn
    end

    # @return [Array<MatchEvent>]
    def perform
      # @param move_turn_effect [MoveTurnEffect]
      move_turn_effects.map do |move_turn_effect|
        case move_turn_effect.effect_type
        when 'relocation'
          # TODO: This logic needs to be way more complex
          CombatantsPlayersMatches::Relocate(
            board_position: board_position,
            combatants_players_match: combatants_players_match,
            match_turn: match_turn
          )
        end
      end
    end

    private

    # @return [MatchTurnsMoveTurn]
    attr_reader :match_turns_move_turn

    # @return [BoardPosition]
    def board_position
      match_turns_move_turn.board_position
    end

    # @return [CombatantsPlayersMatch]
    def combatants_players_match
      match_turns_move_turn.combatants_players_match
    end

    # @return [MatchTurn]
    def match_turn
      match_turns_move_turn.match_turn
    end

    # @return [Array<MoveTurnEffect>]
    def move_turn_effects
      move_turn.effects.all
    end

    # @return [MoveTurn]
    def move_turn
      match_turns_move_turn.move_turn
    end
  end
end
