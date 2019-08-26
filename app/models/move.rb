class Move < ApplicationRecord
  has_many :turns, class_name: 'MoveTurn'
end
