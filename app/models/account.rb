# frozen_string_literal: true

# A registered entity that owns [Combatant]s and participates in [Match]es
class Account < ApplicationRecord
  has_many :combatants,
           class_name: 'AccountCombatant',
           dependent: :restrict_with_exception
  has_many :players,
           dependent: :restrict_with_exception
  has_many :matches,
           through: :players

  # @!attribute [rw] combatants
  #   @return [ActiveRecord::Relation<AccountCombatant>]

  # @!method id()
  #   @return [Integer]

  # @!attribute [w] username
  #   @return [String, nil]

  # @!method username()
  #   @return [String, nil]
end
