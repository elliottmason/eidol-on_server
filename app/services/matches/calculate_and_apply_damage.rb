module Matches
  class CalculateAndApplyDamage < ApplicationService
    # @param board_position [BoardPosition]
    # @param match_move_turn [MatchMoveTurn]
    # @param move_turn_effect [MoveTurnEffect]
    # @param source_combatant [MatchCombatant]
    def initialize(
      board_position:,
      match_combatant:,
      match_move_turn:,
      move_turn_effect:
    )
      @board_position = board_position
      @match_move_turn = match_move_turn
      @move_turn_effect = move_turn_effect
      @source_combatant = match_combatant
    end

    def perform
      ActiveRecord::Base.transaction do
        targets.each do |target_combatant|
          amount =
            MoveTurnEffects::CalculateDamage.for(
              move_turn_effect: move_turn_effect,
              source_combatant: source_combatant,
              target_combatant: target_combatant
            ).value

          MatchCombatants::ApplyDamage.with(
            amount: amount,
            combatant: target_combatant
          )

          create_match_event(
            amount: amount,
            combatant: target_combatant
          )
        end
      end
    end

    private

    # @return [BoardPosition]
    attr_reader :board_position

    # @return [MatchMoveTurn]
    attr_reader :match_move_turn

    # @return [MoveTurnEffect]
    attr_reader :move_turn_effect

    # @return [MatchCombatant]
    attr_reader :source_combatant

    # @return [MatchEvent]
    def create_match_event(amount:, combatant:)
      MatchEvent.create!(
        match_combatant: combatant,
        match_move_turn: match_move_turn,
        move_turn_effect: move_turn_effect,
        effect_type: 'damage',
        amount: amount,
        status: 'successful'
      )
    end

    # @return [MatchCombatant::ActiveRecord_Relation]
    def targets
      board_position.occupants
    end
  end
end
