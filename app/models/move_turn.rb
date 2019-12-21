# frozen_string_literal: true

# Selected Moves may occupy a Combatant for more than a single turn; MoveTurn
# represents this and is used to establish a queue for current and future turns
class MoveTurn < ApplicationRecord
  belongs_to :move
  has_many :effects,
           class_name: 'MoveTurnEffect',
           dependent: :restrict_with_exception
  has_many :match_move_turns,
           dependent: :restrict_with_exception

  # @!attribute [rw] move
  #   @return [Move]

  # @!attribute [rw] turn
  #   @return [Integer]
end
