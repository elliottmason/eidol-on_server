# frozen_string_literal: true

module MoveEffects
  # Processes a single [MoveEffect] relative to the [MatchCombatant] that
  # it's coming from and which [BoardPosition] it targets
  class ProcessDamage < ApplicationService
    def initialize(
      board_position:,
      match_combatant:,
      match_turns_move:,
      move_effect:
    )
      @board_position = board_position
      @match_turns_move = match_turns_move
      @move_effect = move_effect
      @source_combatant = match_combatant
    end

    def allowed?
      source_combatant.queued?
    end

    def perform
      ActiveRecord::Base.transaction do
        targets.each do |target_combatant|
          amount ||= 0 - calculate_damage(target_combatant)

          MatchCombatants::AdjustRemainingHealth.with(
            amount: amount,
            match_combatant: target_combatant
          )

          create_match_event(amount: amount, combatant: target_combatant)
        end
      end
    end

    private

    attr_reader :board_position

    def calculate_damage(target_combatant)
      MoveEffects::CalculateDamage.for(
        move_effect: move_effect,
        source_combatant: source_combatant,
        target_combatant: target_combatant
      ).value
    end

    def create_match_event(amount:, combatant:)
      MatchEvent.create!(
        match_combatant: combatant,
        match_turns_move: match_turns_move,
        move_effect: move_effect,
        amount: amount,
        category: 'damage',
        property: 'normal',
        status: 'successful'
      )
    end

    attr_reader :match

    attr_reader :match_turns_move

    attr_reader :move_effect

    attr_reader :source_combatant

    def targets
      board_position.occupants
    end
  end
end
