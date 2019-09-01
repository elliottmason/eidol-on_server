class BoardPositionsMatchCombatant < ApplicationRecord
  belongs_to :board_event, optional: true
  belongs_to :board_position
  belongs_to :match_combatant

  def self.latest
    order('created_at DESC')
  end
end
