# frozen_string_literal: true

# MatchTurn uniquely represents a round that has or will take place in the
# associate Match, during which moves will be processed and events will occur
class MatchTurn < ApplicationRecord
  belongs_to :match
  has_many :move_selections,
           class_name: 'CombatantsPlayersMatchesMoveSelection',
           dependent: :destroy
  has_many :match_turns_move_turns,
           dependent: :destroy
  has_many :move_turns, through: :match_turns_move_turns
end
