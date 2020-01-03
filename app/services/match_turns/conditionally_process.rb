# frozen_string_literal: true

module MatchTurns
  # Run MatchTurns::Process if all of the combatants appear to be queued or
  # otherwise unavailable
  class ConditionallyProcess < ApplicationService
    # @param match_turn [MatchTurn]
    def initialize(match_turn:)
      @match_turn = match_turn
    end

    # @return [void]
    def perform
      return unless available_combatants.count.zero?

      MatchTurns::Process.for(match_turn: match_turn)
    end

    private

    # @return [ActiveRecord::Relation<MatchCombatant>]
    def available_combatants
      match.combatants.available.all
    end

    # @!method match()
    #   @return [Match]
    delegate :match, to: :match_turn

    # @return [MatchTurn]
    attr_reader :match_turn
  end
end
