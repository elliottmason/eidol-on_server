# frozen_string_literal: true

module Matches
  # Processes a single [MoveTurnEffect] relative to the [MatchCombatant] that
  # it's coming from and which [BoardPosition] it targets
  class ProcessDamage < ApplicationService
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
      @match_move_turn = match_move_turn
      @move_turn_effect = move_turn_effect
      @source_combatant = match_combatant
    end

    # @return [MatchEvent]
    def perform
      ActiveRecord::Base.transaction do
        # @param target_combatant [MatchCombatant]
        targets.each do |target_combatant|
          # @type [Integer]
          amount ||=
            MoveTurnEffects::CalculateDamage.for(
              move_turn_effect: move_turn_effect,
              source_combatant: source_combatant,
              target_combatant: target_combatant
            ).value

          MatchCombatants::ApplyDamage.with(
            amount: amount,
            combatant: target_combatant
          )

          MatchCombatants::UpdateAvailability.with(combatant: target_combatant)

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

    # @return [Match]
    attr_reader :match

    # @return [MatchMoveTurn]
    attr_reader :match_move_turn

    # @return [MoveTurnEffect]
    attr_reader :move_turn_effect

    # @return [MatchCombatant]
    attr_reader :source_combatant

    # @param amount [Integer]
    # @param combatant [MatchCombatant]
    # @return [MatchEvent]
    def create_match_event(amount:, combatant:)
      MatchEvent.create!(
        match_combatant: combatant,
        match_move_turn: match_move_turn,
        move_turn_effect: move_turn_effect,
        amount: amount,
        category: 'damage',
        property: 'normal',
        status: 'successful'
      )
    end

    # @return [ActiveRecord::Relation]
    def targets
      board_position.occupants
    end
  end
end
