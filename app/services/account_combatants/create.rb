# frozen_string_literal: true

module AccountCombatants
  class Create < ApplicationService
    class << self
      def random_individual_value
        rand(0..31)
      end

      alias random_iv random_individual_value
    end

    attr_reader :account_combatant

    def initialize(
      account:,
      combatant:
    )
      @account = account
      @combatant = combatant
    end

    def perform
      ActiveRecord::Base.transaction do
        copy_combatant
        create_combatant_status
        # copy_moves
      end
    end

    private

    attr_reader :account

    attr_reader :combatant

    def copy_combatant
      individual_defense, individual_health, individual_power,
        individual_agility = 4.times.map { self.class.random_iv }

      @account_combatant =
        AccountCombatant.create!(
          account: account,
          combatant: combatant,
          individual_agility: individual_agility,
          individual_defense: individual_defense,
          individual_health: individual_health,
          individual_power: individual_power
        )
    end

    def create_combatant_status
      AccountCombatantStatus.create!(
        account_combatant: account_combatant,
        exp: 1_000
      )
    end
  end
end
