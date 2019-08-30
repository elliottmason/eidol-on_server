# frozen_string_literal: true

class Move < ApplicationRecord
  has_many :turns, class_name: 'MoveTurn', dependent: :destroy

  # @!method turns()
  #   @return [ActiveRecord::Associations::CollectionProxy<MoveTurn>]
end
