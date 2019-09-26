class Player < ApplicationRecord
  has_many :player_combatants
  has_many :statuses, class_name: 'PlayerStatus'
end
