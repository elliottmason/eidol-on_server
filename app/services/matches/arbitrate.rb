# frozen_string_literal: true

module Matches
  # Check to see if anyone has won the match, and update [Match] and [Player]
  # records accordingly
  class Arbitrate < ApplicationService
    # @param match [Match]
    def initialize(match)
      @match = match
    end

    # return [Boolean]
    def allowed?
      match.ended_at.blank?
    end

    # return [nil]
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

    # @return [Match]
    attr_reader :match

    # @return [ActiveRecord::Associations::CollectionProxy<Player>]
    def players
      @players ||= match.players
    end

    # @return [Array<Player>]
    def players_with_available_combatants
      @players_with_available_combatants ||=
        players - players_with_no_available_combatants
    end

    # @return [Array<Player>]
    def players_with_no_available_combatants
      @players_with_no_available_combatants ||=
        players.select do |player|
          player.combatants.available.empty?
        end
    end
  end
end
