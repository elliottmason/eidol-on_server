# frozen_string_literal: true

module Boards
  # Generates a new Board and all of the associated BoardPositions
  class Create < ApplicationService
    BOARD_SIZE = 4

    # @return [Board]
    attr_reader :board

    # @return [Integer]
    def board_size
      BOARD_SIZE
    end

    # @return [Board]
    def perform
      @board = Board.create!

      # Generate all of the BoardPositions based on the board size
      (0...board_size).to_a.repeated_permutation(2).map do |pair|
        x_coordinate, y_coordinate = pair
        BoardPosition.create!(board: board, x: x_coordinate, y: y_coordinate)
      end
    end
  end
end
