# frozen_string_literal: true

# [Move]s that belong to a [MatchCombatant] to isolate available moves from
# the [AccountCombatant] they were copied from
class MatchCombatantsMove < ApplicationRecord
  belongs_to :match_combatant
  belongs_to :move

  # @!method id()
  #   @return [Integer, NilClass]

  # @!method match_combatant()
  #   @return [MatchCombatant, NilClass]

  # @!method move()
  #   @return [Move, NilClass]

  # @return [Match, NilClass]
  def match
    match_combatant&.match
  end
end
