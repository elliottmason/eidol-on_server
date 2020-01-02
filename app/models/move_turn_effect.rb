# frozen_string_literal: true

# Represents the potentially multiple types of damage and status effects that
# can occur as result of a single [MoveTurn]
class MoveTurnEffect < ApplicationRecord
  CATEGORIES =
    {
      damage: %i[
        cutting
        crushing
        direct
        electric
      ],
      relocation: %i[
        normal
      ],
      status_effect: %i[
        poison
      ]
    }.freeze

  belongs_to :move_turn

  # @!method category()
  #   @return [String]
end
