# frozen_string_literal: true

# Unique position on a Board with x and y coordinates
class BoardPosition < ApplicationRecord
  belongs_to :board

  # Get the [MatchCombatant]s whose most recent status has this [BoardPosition]
  # @return [MatchCombatant::ActiveRecord_Relation]
  def occupants
    MatchCombatant \
      .joins(
        <<-SQL
        LEFT JOIN match_combatant_statuses mcs ON (
          mcs.match_combatant_id = match_combatants.id
          AND NOT EXISTS (
            SELECT id FROM match_combatant_statuses mcs1
            WHERE mcs1.match_combatant_id = mcs.match_combatant_id
            AND mcs1.id > mcs.id
          )
        )
        SQL
      ) \
      .where('mcs.board_position_id = ?', self.id)
  end
end
