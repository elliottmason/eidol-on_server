# frozen_string_literal: true

# A unique Combatant character/hero/species that exists within the game
class Combatant < ApplicationRecord
  has_many :account_combatants,
           dependent: :restrict_with_exception
  has_many :match_combatants,
           through: :account_combatants
end
