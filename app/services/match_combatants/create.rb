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
        copy_combatant
        create_combatant_status
        copy_moves
      end
    end

    private

    # @return [AccountCombatant]
    attr_reader :account_combatant

    # @return [Player]
    attr_reader :player

    # @return [MatchCombatant]
    def copy_combatant
      @match_combatant =
        MatchCombatant.create!(
          account_combatant: account_combatant,
          defense: 15,
          health: 50,
          level: 1,
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

    def create_combatant_status
      health = match_combatant.health
      MatchCombatantStatus.create!(
        match_combatant: match_combatant,
        defense: match_combatant.defense,
        level: match_combatant.level,
        maximum_energy: 15,
        maximum_health: health,
        remaining_energy: 2,
        remaining_health: health,
        availability: 'benched'
      )
    end

    # @return [Match]
    def match
      player.match
    end
  end
end
