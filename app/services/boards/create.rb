# frozen_string_literal: true

module Boards
  # Generates a new Board and all of the associated BoardPositions
  class Create < ApplicationService
    BOARD_SIZE = 4

    attr_reader :board

    def initialize(match:)
      @match = match
    end

    private

    attr_reader :match

    def perform
      ActiveRecord::Base.transaction do
        # Generate all of the BoardPositions based on the board size
        @board =
          (0...BOARD_SIZE).to_a.repeated_permutation(2).map do |pair|
            x_coordinate, y_coordinate = pair
            BoardPosition.create!(
              match: match,
              x: x_coordinate,
              y: y_coordinate
            )
          end
      end
    end
  end
end
