# frozen_string_literal: true

# Represents the potentially multiple types of damage and status effects that
# can occur as result of a single [Move]
class MoveEffect < ApplicationRecord
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

  belongs_to :move
end
