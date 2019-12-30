# frozen_string_literal: true

# Records a [MatchCombatantsMove] being selected, assuming for some reason that
# the player who owns the [MatchCombatant] is definitely the one who selected
# the move
class MatchMoveSelection < ApplicationRecord
  belongs_to :board_position, optional: true
  belongs_to :match_combatants_move
  belongs_to :match_turn
  belongs_to :player, optional: true

  delegate :match_combatant, to: :match_combatants_move
  delegate :move, to: :match_combatants_move

  # @!attribute [rw] board_position
  #   @return [BoardPosition, nil]

  # @!method match_combatant()
  #   @return [MatchCombatant]

  # @!attribute [rw] match_combatants_move
  #   @return [MatchCombatantsMove]

  # @!attribute [rw] match_turn
  #   @return [MatchTurn]

  # @!method move()
  #   @return [Move]

  # @!attribute [rw] player
  #   @return [Player, nil]
end
