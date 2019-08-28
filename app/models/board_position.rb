# frozen_string_literal: true

# Unique position on a Board with x and y coordinates
class BoardPosition < ApplicationRecord
  belongs_to :board
end
