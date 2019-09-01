# frozen_string_literal: true

# [Move]s that belong to a [Player]'s unique instance of a [Combatant],
# that is, a [PlayerCombatant]
class PlayerCombatantsMove < ApplicationRecord
  belongs_to :player_combatant
  belongs_to :move
end
