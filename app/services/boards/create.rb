# frozen_string_literal: true

module Boards
  # Generates a new Board and all of the associated BoardPositions
  class Create < ApplicationService
    BOARD_SIZE = 4

    attr_reader :board

    def board_size
      BOARD_SIZE
    end

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
