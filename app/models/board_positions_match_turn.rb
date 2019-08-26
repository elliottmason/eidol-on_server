class BoardPositionsMatchTurn < ApplicationRecord
  belongs_to :board_position
  belongs_to :match_turn
end
