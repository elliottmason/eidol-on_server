# frozen_string_literal: true

# A container for [BoardPosition]s that is associated with a [Match]
class Board < ApplicationRecord
  has_many :positions,
           class_name: 'BoardPosition',
           dependent: :restrict_with_exception
end
