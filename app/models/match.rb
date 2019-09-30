# frozen_string_literal: true

# Encompasses a unique Match between two or more [Player]s, their
# [MatchCombatant], and the [MatchTurn]s during which [MoveTurn]s take place
class Match < ApplicationRecord
  has_many :board_positions, dependent: :restrict_with_exception
  has_many :match_combatants, dependent: :restrict_with_exception
  has_many :account_combatants, through: :match_combatants
  has_many :players, dependent: :restrict_with_exception
  has_many :turns, class_name: 'MatchTurn', dependent: :restrict_with_exception
  has_many :match_move_turns, through: :turns
  has_many :events,
           class_name: 'MatchEvent',
           through: :match_move_turns,
           source: :match_events

  # @!attribute [r] id
  #   @return [Integer]

  # @!attribute [rw] players
  #   @return [ActiveRecord::Associations::CollectionProxy<Player>]

  # @!attribute [rw] turns
  #   @return [ActiveRecord::Associations::CollectionProxy]

  # @return [MatchTurn, nil]
  def turn
    turns.where(processed_at: nil).order('turn ASC').first
  end
end
