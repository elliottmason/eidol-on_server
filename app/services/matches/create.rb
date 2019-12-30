# frozen_string_literal: true

module Matches
  # Creates a new [Match] between two (or more?) [Account]s
  class Create < ApplicationService
    # @return [Match]
    attr_reader :match

    # @param accounts [Array<Account>]
    def initialize(accounts:)
      @accounts = accounts
    end

    def perform
      ActiveRecord::Base.transaction do
        create_match
        create_board
        create_players
      end
    end

    private

    # @return [Array<Account>]
    attr_reader :accounts

    # @return [Array<BoardPosition>]
    def create_board
      board_creator = Boards::Create.for(match: match)
      @board = board_creator.board
    end

    # @return [Match]
    def create_match
      @match = Match.create!.tap do |match|
        MatchTurn.create!(match: match, turn: 0)
      end
    end

    # @return [Array<Player>]
    def create_players
      accounts.map do |account|
        player =
          Player.create!(
            account: account,
            match: match,
            name: account.username
          )
        service = Players::CreateMatchCombatants.for(player)
        service.player
      end
    end
  end
end
