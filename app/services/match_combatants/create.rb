# frozen_string_literal: true

module MatchCombatants
  # Creates a copy of an [Account]'s [Combatant] that can be manipulated in the
  # context of a Match
  class Create < ApplicationService
    # @return [MatchCombatant]
    attr_reader :match_combatant

    # @param account_combatant [AccountCombatant]
    # @param player [Player]
    def initialize(
      account_combatant:,
      player:
    )
      @account_combatant = account_combatant
      @player = player
    end

    # TODO: create real stats
    def perform
      ActiveRecord::Base.transaction do
        copy_account_combatant
        create_combatant_status
        copy_moves
      end
    end

    private

    # @return [AccountCombatant]
    attr_reader :account_combatant

    # @return [Player]
    attr_reader :player

    # TODO: These are fake stats tho
    # @return [MatchCombatant]
    def copy_account_combatant
      @match_combatant =
        MatchCombatant.create!(
          account_combatant: account_combatant,
          defense: defense,
          health: health,
          level: level,
          player: player
        )
    end

    # TODO: could this be its own service?
    # @return [Array<MatchCombatantsMove>]
    def copy_moves
      account_combatant.moves.map do |move|
        MatchCombatantsMove.create!(
          match_combatant: match_combatant,
          move: move
        )
      end
    end

    # @return [Combatant]
    def combatant
      account_combatant.combatant
    end

    # @return [MatchCombatantStatus]
    def create_combatant_status
      health = match_combatant.health
      MatchCombatantStatus.create!(
        match_combatant: match_combatant,
        remaining_energy: remaining_energy,
        remaining_health: health,
        availability: 'benched'
      )
    end

    # @return [Integer]
    def defense
      AccountCombatants::CalculateDefense.with(account_combatant).value
    end

    # @return [Integer]
    def health
      AccountCombatants::CalculateHealth.with(account_combatant).value
    end

    # @return [Integer]
    def level
      AccountCombatants::CalculateLevel.with(account_combatant).value
    end

    # @return [Match]
    def match
      player.match
    end

    # @return [Integer]
    def remaining_energy
      combatant.initial_remaining_energy
    end
  end
end
