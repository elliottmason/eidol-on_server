# frozen_string_literal: true

module MatchCombatants
  # Conditionally inserts an updated [MatchCombatantStatus] based on changes
  # to the [MatchCombatant]'s health or current capacity to queue moves
  class UpdateAvailability < ApplicationService
    def initialize(match_combatant)
      @match_combatant = match_combatant
    end

    def allowed?
      !status.knocked_out?
    end

    def perform
      if combatant_out_of_health?
        MatchCombatants::KnockOut.with(match_combatant)
      elsif combatant_now_queued?
        new_status.queued!
      elsif combatant_now_available?
        new_status.available!
      end
    end

    private

    attr_reader :match_combatant

    delegate :status, to: :match_combatant

    def combatant_now_available?
      status.queued? && unprocessed_match_turns_moves.blank?
    end

    def combatant_now_queued?
      unprocessed_match_turns_moves.present?
    end

    def combatant_out_of_health?
      status.remaining_health <= 0
    end

    def new_status
      @new_status ||= status.dup
    end

    def unprocessed_match_turns_moves
      match_combatant.match_turns_moves.unprocessed
    end
  end
end
