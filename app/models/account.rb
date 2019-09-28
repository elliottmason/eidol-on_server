class Account < ApplicationRecord
  has_many :account_combatants
  has_many :players
  has_many :matches, through: :players
end
