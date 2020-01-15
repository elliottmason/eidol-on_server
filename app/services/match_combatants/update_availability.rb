# frozen_string_literal: true

module MatchCombatants
  # Conditionally inserts an updated [MatchCombatantStatus] based on changes
  # to the [MatchCombatant]'s health or current capacity to queue moves
  class UpdateAvailability < ApplicationService
    # @param match_combatant [MatchCombatant]
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

    # @return [MatchCombatant]
    attr_reader :match_combatant

    # @!method status()
    #   @return [MatchCombatantStatus]
    delegate :status, to: :match_combatant

    # @return [Boolean]
    def combatant_now_available?
      status.queued? && unprocessed_match_turns_moves.blank?
    end

    # @return [Boolean]
    def combatant_now_queued?
      unprocessed_match_turns_moves.present?
    end

    # @return [Boolean]
    def combatant_out_of_health?
      status.remaining_health <= 0
    end

    # @return [MatchCombatantStatus]
    def new_status
      @new_status ||= status.dup
    end

    # @return [ActiveRecord::Relation<MatchTurnsMove>]
    def unprocessed_match_turns_moves
      match_combatant.match_turns_moves.unprocessed
    end
  end
end
