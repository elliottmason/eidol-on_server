# frozen_string_literal: true

# A [Player]'s unique instance of a [Combatant] with its own progression and
# stats
class PlayerCombatant < ApplicationRecord
  belongs_to :combatant
  belongs_to :player
  has_many :player_combatants_moves, dependent: :restrict_with_exception
  has_many :moves, through: :player_combatants_moves
end
