# frozen_string_literal: true

module MatchCombatants
  # This basically just K.O.'s [MatchCombatant]s and removes them from the board
  # when their remaining_health drops too low by inserting a new status
  class UpdateAvailability < ApplicationService
    # @param match_combatant [MatchCombatant]
    def initialize(match_combatant:)
      @match_combatant = match_combatant
    end

    def allowed?
      !status.knocked_out?
    end

    def perform
      if combatant_out_of_health?
        new_status.board_position = nil
        new_status.knocked_out!
      elsif combatant_now_available?
        new_status.available!
      end
    end

    private

    # @return [MatchCombatant]
    attr_reader :match_combatant

    # @!method status()
    #   @return [MatchCombatantStatus]
    delegate :status, to: :match_combatant

    # @return [Boolean]
    def combatant_now_available?
      status.queued? && match_combatant.match_move_turns.unprocessed.empty?
    end

    # @return [Boolean]
    def combatant_out_of_health?
      status.remaining_health <= 0
    end

    # @return [MatchCombatantStatus]
    def new_status
      @new_status ||= status.dup
    end
  end
end
