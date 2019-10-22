# frozen_string_literal: true

module MatchCombatants
  # This basically just K.O.'s [MatchCombatant]s and removes them from the board
  # when their remaining_health drops too low by inserting a new status
  class UpdateAvailability < ApplicationService
    # @param match_combatant [MatchCombatant]
    def initialize(match_combatant:)
      @match_combatant = match_combatant
    end

    def perform
      return unless status.remaining_health <= 0

      new_status = status.dup

      new_status.board_position = nil
      new_status.availability = 'knocked_out'

      new_status.save!
    end

    private

    # @return [MatchCombatant]
    attr_reader :match_combatant

    # @return [MatchCombatantStatus]
    delegate :status, to: :match_combatant
  end
end
