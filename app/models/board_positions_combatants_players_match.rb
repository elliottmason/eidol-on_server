# frozen_string_literal: true

# Locates a [CombatantsPlayersMatch] on a unique [BoardPosition]
class BoardPositionsCombatantsPlayersMatch < ApplicationRecord
  belongs_to :board_position
  belongs_to :combatants_players_match
  belongs_to :match_turn
end
