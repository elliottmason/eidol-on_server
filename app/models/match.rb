class Match < ApplicationRecord
  belongs_to :board
  has_many :combatants_players_matches
  has_many :combatants_players, through: :combatants_players_matches
  has_many :matches_players
  has_many :players, through: :matches_players
  has_many :turns, class_name: 'MatchTurn'
end
