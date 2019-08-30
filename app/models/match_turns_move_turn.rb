# frozen_string_literal: true

# The effective queue of [MoveTurn]s for a [MatchTurn], and the
# [CombatantsPlayerMatch] that is using the move
class MatchTurnsMoveTurn < ApplicationRecord
  belongs_to :combatants_players_matches_move_selection, required: false
  belongs_to :combatants_players_match
  belongs_to :match_turn
  belongs_to :move_turn

  delegate :board_position, to: :combatants_players_matches_move_selection

  # @!attribute combatants_players_matches_move_selection
  #   @return [CombatantsPlayersMatchesMoveSelection]

  # @!attribute move_turn
  #   @return [MoveTurn]

  # @!attribute combatants_players_match
  #   @return [CombatantsPlayersMatch]
end
