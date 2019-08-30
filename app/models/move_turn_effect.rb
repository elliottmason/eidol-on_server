# frozen_string_literal: true

class MoveTurnEffect < ApplicationRecord
  belongs_to :move_turn

  # @!attribute [rw] effect_type
  #   @return [String]
end
