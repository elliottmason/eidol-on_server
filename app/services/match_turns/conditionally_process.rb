# frozen_string_literal: true

module MatchTurns
  # Run MatchTurns::Process if all of the combatants appear to be queued or
  # otherwise unavailable
  class ConditionallyProcess < ApplicationService
    def initialize(match_turn:)
      @match_turn = match_turn
    end

    def perform
      return unless available_combatants.count.zero?

      MatchTurns::Process.for(match_turn: match_turn)
    end

    private

    def available_combatants
      match.combatants.available.all
    end

    delegate :match, to: :match_turn

    attr_reader :match_turn
  end
end
