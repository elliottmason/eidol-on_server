# frozen_string_literal: true

module Matches
  # Check to see if anyone has won the match, and update [Match] and [Player]
  # records accordingly
  class Arbitrate < ApplicationService
    def initialize(match)
      @match = match
    end

    def allowed?
      match.ended_at.blank?
    end

    def perform
      return if players_with_no_available_combatants.empty?

      # TODO: separate service that ends a match and declares winners?
      ActiveRecord::Base.transaction do
        match.update!(ended_at: Time.now.utc)

        players_with_available_combatants.each do |player|
          player.update!(rank: 1)
        end

        players_with_no_available_combatants.each do |player|
          player.update!(rank: 2)
        end
      end
    end

    private

    attr_reader :match

    def players
      @players ||= match.players
    end

    def players_with_available_combatants
      @players_with_available_combatants ||=
        players - players_with_no_available_combatants
    end

    def players_with_no_available_combatants
      @players_with_no_available_combatants ||=
        players.select do |player|
          player.combatants.available.empty?
        end
    end
  end
end
