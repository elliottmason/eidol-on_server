# frozen_string_literal: true

module Matches
  # Creates a new Match between two (or more?) Players
  class Create < ApplicationService
    attr_reader :match

    def initialize(players:)
      @players = players
    end

    def perform
      ActiveRecord::Base.transaction do
        create_board
        create_match
        create_combatants
      end
    end

    private

    attr_reader :board
    attr_reader :players

    def create_board
      board_creator = Boards::Create.now
      @board = board_creator.board
    end

    def create_combatants
      players.map(&:combatants_players).flatten.each do |combatants_player|
        CombatantsPlayersMatches::Create.with(
          combatants_player: combatants_player,
          match: match
        )
      end
    end

    def create_match
      @match = Match.create!(board: board)
      match.players = players
      MatchTurn.create!(match: match, turn: 1)
    end
  end
end
