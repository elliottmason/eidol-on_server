# frozen_string_literal: true

# An [Account]'s unique instance of a [Combatant] with its own progression and
# stats
class AccountCombatant < ApplicationRecord
  belongs_to :account
  belongs_to :combatant
  has_many :account_combatants_moves, dependent: :restrict_with_exception
  has_many :moves, through: :account_combatants_moves
  has_many :match_combatants, dependent: :restrict_with_exception
  has_many :statuses,
           class_name: 'AccountCombatantStatus',
           dependent: :restrict_with_exception

  # @!method statuses()
  #   @return [ActiveRecord::Relation<AccountCombatantStatus>]

  # @return [AccountCombatantStatus]
  def status
    statuses.order('created_at DESC').first
  end
end
