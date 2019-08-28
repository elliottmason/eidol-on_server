class Board < ApplicationRecord
  has_many :positions, class_name: 'BoardPosition'
end
