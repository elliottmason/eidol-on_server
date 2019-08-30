# frozen_string_literal: true

# A [MoveTurnEffect] that's been processed and resolved by the game server
class MatchTurnsMoveTurnsMoveTurnEffect < ApplicationRecord
  belongs_to :board_position
  belongs_to :combatants_players_match
  belongs_to :match_turns_move_turn
  belongs_to :move_turn_effect
end
