# frozen_string_literal: true

module MatchCombatants
  # Inserts a new [MatchCombatantStatus] that assigns it a [BoardPosition]
  # and makes it available to perform moves
  class Deploy < ApplicationService
    def initialize(
      board_position:,
      match_combatant:
    )
      @board_position = board_position
      @match_combatant = match_combatant
    end

    def allowed?
      match_combatant.benched?
    end

    def perform
      ActiveRecord::Base.transaction do
        new_status = match_combatant.status.dup
        new_status.update!(
          availability: 'available',
          board_position: board_position
        )
      end
    end

    private

    attr_reader :board_position

    attr_reader :match_combatant
  end
end
