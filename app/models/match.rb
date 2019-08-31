class Match < ApplicationRecord
  belongs_to :board
  has_many :combatants_players_matches, dependent: :destroy
  has_many :combatants_players, through: :combatants_players_matches
  has_many :matches_players, dependent: :destroy
  has_many :players, through: :matches_players
  has_many :turns, class_name: 'MatchTurn', dependent: :destroy

  # @!attribute [rw] board
  #   @return [Board]
  # @!attribute [rw] turns
  #   @return [ActiveRecord::Associations::CollectionProxy]

  # @return [MatchTurn]
  def current_turn
    turns.where(processed_at: nil).order('turn ASC').first
  end
end
