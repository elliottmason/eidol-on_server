class MoveTurn < ApplicationRecord
  belongs_to :move
  has_many :effects, class_name: 'MoveTurnEffect'
end
