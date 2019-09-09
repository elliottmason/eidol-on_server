# frozen_string_literal: true

# Represents a move that a [Combatant] can perform in a Match
class Move < ApplicationRecord
  has_many :turns, class_name: 'MoveTurn', dependent: :restrict_with_exception

  # @!method turns()
  #   @return [ActiveRecord::Associations::CollectionProxy<MoveTurn>]
end
