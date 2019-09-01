module MatchCombatants
  class ApplyDamage < ApplicationService
    # @param board_position [BoardPosition]
    # @param match_combatant [MatchCombatant]
    # @param match_move_turn [MatchMoveTurn]
    # @param move_turn_effect [MoveTurnEffect]
    def initialize(
      board_position:,
      match_combatant:,
      match_move_turn:,
      move_turn_effect:
    )
      @board_position = board_position
      @match_combatant = match_combatant
      @match_move_turn = match_move_turn
      @move_turn_effect = move_turn_effect
    end

    def perform
      board_position.occupants.each do |target_combatant|
        MoveTurnEffects::CalculateDamage.for(
          move_turn_effect: move_turn_effect,
          target_combatant: target_combatant
        )
      end
    end

    private

    # @return [BoardPosition]
    attr_reader :board_position

    # @return [MoveTurnEffect]
    attr_reader :move_turn_effect
  end
end
