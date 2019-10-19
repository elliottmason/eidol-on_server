# frozen_string_literal: true

# A snapshot based on an [AccountCombatant] to manipulate in the context of a
# [Match]
class MatchCombatant < ApplicationRecord
  belongs_to :account_combatant
  belongs_to :match
  has_many :board_positions, through: :statuses
  has_many :match_combatants_moves, dependent: :restrict_with_exception
  has_many :moves, through: :match_combatants_moves
  has_many :statuses,
           class_name: 'MatchCombatantStatus',
           dependent: :restrict_with_exception
  has_one :combatant, through: :account_combatant

  def self.available
    availability = 'available'

    joins(
      <<-SQL
        INNER JOIN match_combatant_statuses mcs ON (
          mcs.id = (
            SELECT mcs1.id
            FROM match_combatant_statuses AS mcs1
            WHERE mcs1.match_combatant_id = match_combatants.id
            ORDER BY mcs1.id DESC
            LIMIT 1
          )
        )
      SQL
    ).where(mcs: { availability: availability }).distinct
  end

  def self.deployed
    joins(
      <<-SQL
        INNER JOIN match_combatant_statuses mcs ON (
          mcs.id = (
            SELECT mcs1.id
            FROM match_combatant_statuses AS mcs1
            WHERE mcs1.match_combatant_id = match_combatants.id
            ORDER BY mcs1.id DESC
            LIMIT 1
          )
        )
      SQL
    ).where.not(mcs: { board_position_id: nil }).distinct
  end

  # @!method match_combatants_moves()
  #   @return [ActiveRecord::Associations::CollectionProxy<MatchCombatantsMove>]

  # @!method statuses()
  #   @return [ActiveRecord::Associations::CollectionProxy<MatchCombatantStatus>]

  # @return [Account]
  def account
    account_combatant.account
  end

  # @return [Player]
  def player
    @player ||=
      Player.where(account: account, match: match).select(:id).first
  end

  # @return [Integer]
  def player_id
    player.id
  end

  # @return [BoardPosition]
  def position
    status.board_position
  end

  # @return [MatchCombatantStatus]
  def status
    statuses.order('created_at DESC').first
  end
end
