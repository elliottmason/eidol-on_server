# frozen_string_literal: true

module MatchCombatants
  # Update the [MatchCombatant]'s availability to knocked_out and remove it from
  # the board, usually as a result of their remaining_health reaching 0
  class KnockOut < ApplicationService
    def initialize(match_combatant)
      @match_combatant = match_combatant
    end

    def perform
      new_status.board_position = nil
      new_status.remaining_health = 0
      new_status.knocked_out!
    end

    private

    attr_reader :match_combatant

    def new_status
      @new_status ||= match_combatant.status.dup
    end
  end
end
