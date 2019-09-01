class MatchCombatantStatus < ApplicationRecord
  belongs_to :match_combatant
  belongs_to :match_event
end
