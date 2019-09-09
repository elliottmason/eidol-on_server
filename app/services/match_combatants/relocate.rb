# frozen_string_literal: true

module MatchCombatants
  # Creates a new [MatchCombatantStatus] for the given [MatchCombatant] that
  # updates their board_position to the given [BoardPosition]
  class Relocate < ApplicationService
    # @param board_position [BoardPosition]
    # @param match_combatant [MatchCombatant]
    # @param match_event [MatchEvent] that caused this change
    def initialize(
      board_position:,
      match_combatant:,
      match_event:
    )
      @board_position = board_position
      @match_combatant = match_combatant
      @match_event = match_event
    end

    # @return [Object]
    def new_status
      @new_status ||= match_combatant.status.dup
    end

    def perform
      update_match_combatant_status
    end

    private

    # @return [BoardPosition]
    attr_reader :board_position

    # @return [MatchCombatant]
    attr_reader :match_combatant

    # @return [MatchEvent]
    attr_reader :match_event

    # @return [MatchCombatantStatus]
    def update_match_combatant_status
      new_status.board_position = board_position
      new_status.match_event = match_event
      new_status.save!
    end
  end
end
