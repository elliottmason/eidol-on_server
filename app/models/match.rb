# frozen_string_literal: true

# Encompasses a unique Match between two or more [Player]s, their
# [MatchCombatant], and the [MatchTurn]s during which [MoveTurn]s take place
class Match < ApplicationRecord
  belongs_to :board
  has_many :match_combatants, dependent: :restrict_with_exception
  has_many :player_combatants, through: :match_combatants
  has_many :matches_players, dependent: :restrict_with_exception
  has_many :players, through: :matches_players
  has_many :turns, class_name: 'MatchTurn', dependent: :restrict_with_exception
  has_many :match_move_turns, through: :turns
  has_many :events,
           class_name: 'MatchEvent',
           through: :match_move_turns,
           source: :match_events

  # @!attribute [rw] board
  #   @return [Board]
  # @!attribute [rw] match_combatants
  #   @return [ActiveRecord::Associations::CollectionProxy]
  # @!attribute [rw] turns
  #   @return [ActiveRecord::Associations::CollectionProxy]

  # @return [MatchTurn, nil]
  def turn
    turns.where(processed_at: nil).order('turn ASC').first
  end
end
