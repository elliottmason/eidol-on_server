class MatchTurn < ApplicationRecord
  belongs_to :match
  has_many :move_selections,
           class_name: 'CombatantsPlayersMatchesMoveSelection'
  has_many :unprocessed_move_selections,
           -> { where(processed_at: nil) },
           class_name: 'CombatantsPlayersMatchesMoveSelection'
end
