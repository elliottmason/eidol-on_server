class Match < ApplicationRecord
  belongs_to :board
  has_many :match_combatants, dependent: :destroy
  has_many :player_combatants, through: :match_combatants
  has_many :matches_players, dependent: :destroy
  has_many :players, through: :matches_players
  has_many :turns, class_name: 'MatchTurn', dependent: :destroy

  # @!attribute [rw] board
  #   @return [Board]
  # @!attribute [rw] match_combatants
  #   @return [ActiveRecord::Associations::CollectionProxy<MatchCombatant>]
  # @!attribute [rw] turns
  #   @return [ActiveRecord::Associations::CollectionProxy<MatchTurn>]

  # @return [MatchTurn, nil]
  def current_turn
    turns.where(processed_at: nil).order('turn ASC').first
  end
end
