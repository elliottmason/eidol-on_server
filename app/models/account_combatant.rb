# frozen_string_literal: true

# An [Account]'s unique instance of a [Combatant] with its own progression and
# stats
class AccountCombatant < ApplicationRecord
  MAX_BASE = 255.0
  MAX_IV = 31.0
  MAX_HEALTH = 500.0
  MAX_LEVEL = 50.0
  MAX_STAT = 999.0

  belongs_to :account
  belongs_to :combatant
  has_many :account_combatants_moves, dependent: :restrict_with_exception
  has_many :moves, through: :account_combatants_moves
  has_many :match_combatants, dependent: :restrict_with_exception
  has_many :statuses,
           class_name: 'AccountCombatantStatus',
           dependent: :restrict_with_exception

  def status
    statuses.order('created_at DESC').first
  end
end
