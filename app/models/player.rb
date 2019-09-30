# frozen_string_literal: true

# Represents the presence of an [Account] as a participant in a [Match]
class Player < ApplicationRecord
  belongs_to :account
  belongs_to :match
  has_many :statuses,
           class_name: 'PlayerStatus',
           dependent: :restrict_with_exception

  # @!attribute [w] id
  #   @return [Integer]

  # @!method id()
  #   @return [Integer]
end
