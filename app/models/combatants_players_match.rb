# frozen_string_literal: true

# A snapshot of a Player's Combatant to manipulate in the context of a match
class CombatantsPlayersMatch < ApplicationRecord
  belongs_to :combatants_player
  belongs_to :match
  has_many :combatants_players_matches_moves
  has_many :moves, through: :combatants_players_matches_moves
end
