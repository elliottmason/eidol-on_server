# frozen_string_literal: true

module MatchCombatants
  # Creates a new [MatchCombatantStatus] for the given [MatchCombatant] that
  # updates their board_position to the given [BoardPosition]
  class Relocate < ApplicationService
    def initialize(
      board_position:,
      match_combatant:,
      match_event:
    )
      @board_position = board_position
      @match_combatant = match_combatant
      @match_event = match_event
    end

    def new_status
      @new_status ||= match_combatant.status.dup
    end

    def perform
      update_match_combatant_status
    end

    private

    attr_reader :board_position

    attr_reader :match_combatant

    attr_reader :match_event

    def update_match_combatant_status
      new_status.board_position = board_position
      new_status.match_event = match_event
      new_status.save!
    end
  end
end
