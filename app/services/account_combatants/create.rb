module AccountCombatants
  class Create < ApplicationService
    class << self
      # @return [Integer]
      def random_individual_value
        Math.rand(0..31)
      end

      # @return [Integer]
      alias random_iv random_individual_value
    end

    # @param account [Account]
    # @param combatant [Combatant]
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

    # @return [Account]
    attr_reader :account

    # @return [AccountCombatant]
    attr_reader :account_combatant

    # @return [Combatant]
    attr_reader :combatant

    # @return [void]
    def copy_combatant
      individual_defense, individual_health, individual_power,
        individual_speed = 4.times.map { self.class.random_iv }

      @account_combatant =
        AccountCombatant.create!(
          account: account,
          combatant: combatant,
          individual_defense: individual_defense,
          individual_health: individual_health,
          individual_power: individual_power,
          individual_speed: individual_speed
        )
    end

    # @return [void]
    def create_combatant_status
      AccountCombatantStatus.create!(
        account_combatant: account_combatant,
        exp: 0,
        defense:
          AccountCombatants::CalculateDefense.for(account_combatant),
        health:
          AccountCombatants::CalculateHealth.for(account_combatant)
      )
    end
  end
end
