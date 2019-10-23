# frozen_string_literal: true

module MatchCombatants
  class Deploy < ApplicationService
    # @param board_position [BoardPosition]
    # @param match_combatant [MatchCombatant]
    def initialize(
      board_position:,
      match_combatant:
    )
      @board_position = board_position
      @match_combatant = match_combatant
    end

    # @return [Boolean]
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

    # @return [BoardPosition]
    attr_reader :board_position

    # @return [MatchCombatant]
    attr_reader :match_combatant
  end
end
