# frozen_string_literal: true

# [Move]s that belong to a [MatchCombatant] to isolate available moves from
# the [PlayerCombatant] they came from
class MatchCombatantsMove < ApplicationRecord
  belongs_to :match_combatant
  belongs_to :move
end
