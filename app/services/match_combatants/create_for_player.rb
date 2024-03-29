# frozen_string_literal: true

module MatchCombatants
  # Create some [MatchCombatant]s from the provided [Player]'s
  # [AccountCombatant]s
  class CreateForPlayer < ApplicationService
    attr_reader :player

    def initialize(player)
      @player = player
    end

    def perform
      account_combatants.each do |account_combatant|
        MatchCombatants::Create.with(
          account_combatant: account_combatant,
          player: player
        )
      end
    end

    private

    def account_combatants
      player.account.combatants
    end
  end
end
