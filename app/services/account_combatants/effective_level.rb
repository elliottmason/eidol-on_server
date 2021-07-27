# frozen_string_literal: true

module AccountCombatants
  # Helps prevent us from multiplying by zero by adding as much as 1 and as
  # little as 0 to the Combatant's true level
  module EffectiveLevel
    MAX_LEVEL = AccountCombatant::MAX_LEVEL

    # Use this value in most calculations involving level to avoid multiplying
    # or dividing by 0
    def effective_level
      level + level_bonus
    end

    def level
      @level ||=
        AccountCombatants::CalculateLevel.with(account_combatant).value
    end

    # Level 0 combatants +1, Level 25 combatants +0
    def level_bonus
      (MAX_LEVEL - level) / MAX_LEVEL
    end
  end
end
