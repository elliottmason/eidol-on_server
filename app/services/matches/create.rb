# frozen_string_literal: true

module Matches
  # Creates a new [Match] between two (or more?) [Account]s
  class Create < ApplicationService
    attr_reader :match

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

    attr_reader :accounts

    def create_board
      board_creator = Boards::Create.for(match: match)
      @board = board_creator.board
    end

    def create_match
      @match = Match.create!.tap do |match|
        MatchTurn.create!(match: match, turn: 0)
      end
    end

    def create_players
      accounts.map do |account|
        player =
          Player.create!(
            account: account,
            match: match,
            name: account.username
          )
        service = MatchCombatants::CreateForPlayer.for(player)
        service.player
      end
    end
  end
end
