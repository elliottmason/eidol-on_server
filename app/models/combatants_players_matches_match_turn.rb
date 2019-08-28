# frozen_string_literal: true

# A Player's updated Combatant as its status transforms during a match
class CombatantsPlayersMatchesMatchTurn < ApplicationRecord
  belongs_to :match
end
