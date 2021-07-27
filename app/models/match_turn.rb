# frozen_string_literal: true

# MatchTurn uniquely represents a round that has or will take place in the
# associate Match, during which moves will be processed and events will occur
class MatchTurn < ApplicationRecord
  belongs_to :match
  has_many :move_selections,
           class_name: 'MatchMoveSelection',
           dependent: :restrict_with_exception
  has_many :match_turns_moves,
           dependent: :restrict_with_exception
  has_many :match_events, through: :match_turns_moves
  has_many :moves, through: :match_turns_moves

  def unprocessed?
    processed_at.blank?
  end
end
