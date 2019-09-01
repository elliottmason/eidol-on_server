# frozen_string_literal: true

module Matches
  # Creates a new Match between two (or more?) Players
  class Create < ApplicationService
    # @return [Match]
    attr_reader :match

    # @param players [Array<Player>]
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

    # @return [Board]
    attr_reader :board

    # @return [Array<Player>]
    attr_reader :players

    # @return [Board]
    def create_board
      board_creator = Boards::Create.now
      @board = board_creator.board
    end

    # @return [Array<MatchCombatant>]
    def create_combatants
      players.map(&:player_combatants).flatten.each do |player_combatant|
        MatchCombatants::Create.with(
          player_combatant: player_combatant,
          match: match
        )
      end
    end

    # @return [Match]
    def create_match
      @match = Match.create!(board: board).tap do |match|
        match.players = players
        MatchTurn.create!(match: match, turn: 0)
      end
    end
  end
end
