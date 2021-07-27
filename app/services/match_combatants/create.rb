# frozen_string_literal: true

module MatchCombatants
  # Creates a copy of an [Account]'s [Combatant] that can be manipulated in the
  # context of a Match
  class Create < ApplicationService
    attr_reader :match_combatant

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

    attr_reader :account_combatant

    attr_reader :player

    def agility
      AccountCombatants::CalculateAgility.with(account_combatant).value
    end

    # TODO: These are fake stats tho
    def copy_account_combatant
      @match_combatant =
        MatchCombatant.create!(
          account_combatant: account_combatant,
          agility: agility,
          defense: defense,
          level: level,
          maximum_energy: energy,
          maximum_health: health,
          player: player
        )
    end

    # TODO: could this be its own service?
    def copy_moves
      account_combatant.moves.map do |move|
        MatchCombatantsMove.create!(
          match_combatant: match_combatant,
          move: move
        )
      end
    end

    def combatant
      account_combatant.combatant
    end

    def create_combatant_status
      remaining_health = match_combatant.maximum_health
      MatchCombatantStatus.create!(
        match_combatant: match_combatant,
        remaining_energy: remaining_energy,
        remaining_health: remaining_health,
        availability: 'benched'
      )
    end

    def defense
      AccountCombatants::CalculateDefense.with(account_combatant).value
    end

    # TODO: should be calculated based on level
    def energy
      combatant.maximum_energy
    end

    def health
      AccountCombatants::CalculateHealth.with(account_combatant).value
    end

    def level
      AccountCombatants::CalculateLevel.with(account_combatant).value
    end

    def match
      player.match
    end

    def remaining_energy
      combatant.initial_remaining_energy
    end
  end
end
