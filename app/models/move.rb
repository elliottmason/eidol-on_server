# frozen_string_literal: true

# Represents a move that a [Combatant] can perform in a Match
class Move < ApplicationRecord
  has_many :effects, class_name: 'MoveEffect',
                     dependent: :restrict_with_exception

  # @!method effects()
  #   @return [ActiveRecord::Relation<MoveEffect>]
end
