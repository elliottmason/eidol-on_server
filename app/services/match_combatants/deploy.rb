module MatchCombatants
  class Deploy < ApplicationService
    def initialize(
      board_position:,
      match_combatant:
    )
      @board_position = board_position
      @match_combatant = match_combatant
    end

    def perform
      ActiveRecord::Base.transaction do
        new_status = match_combatant.status.dup
        new_status.board_position = board_position
        new_status.availability = 'available'
        new_status.save!
      end
    end

    private

    # @return [BoardPosition]
    attr_reader :board_position

    # @return [MatchCombatant]
    attr_reader :match_combatant
  end
end
