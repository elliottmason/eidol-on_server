# frozen_string_literal: true

# [Move]s that belong to a [AccountCombatant]
class AccountCombatantsMove < ApplicationRecord
  belongs_to :account_combatant
  belongs_to :move
end
