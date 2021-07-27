# frozen_string_literal: true

# Encompasses a unique Match between two or more [Player]s, their
# [MatchCombatant], and the [MatchTurn]s during which [Move]s take place
class Match < ApplicationRecord
  has_many :board_positions, dependent: :restrict_with_exception
  has_many :players,
           dependent: :restrict_with_exception
  has_many :combatants, through: :players
  has_many :turns,
           class_name: 'MatchTurn',
           dependent: :restrict_with_exception
  has_many :match_turns_moves, through: :turns
  has_many :events,
           class_name: 'MatchEvent',
           through: :match_turns_moves,
           source: :match_events

  def turn
    turns.where(processed_at: nil).order('turn ASC').first
  end
end
