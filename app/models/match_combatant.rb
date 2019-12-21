# frozen_string_literal: true

# A snapshot based on an [AccountCombatant] to manipulate in the context of a
# [Match]
class MatchCombatant < ApplicationRecord
  belongs_to :account_combatant
  belongs_to :player
  has_many :board_positions,
           through: :statuses
  has_many :match_combatants_moves,
           dependent: :restrict_with_exception
  has_many :match_move_turns,
           dependent: :restrict_with_exception
  has_many :moves,
           through: :match_combatants_moves
  has_many :statuses,
           class_name: 'MatchCombatantStatus',
           dependent: :restrict_with_exception
  has_one :combatant,
          through: :account_combatant
  has_one :match,
          through: :player

  AVAILABLE_JOIN =
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

  DEPLOYED_JOIN =
    <<-SQL
        INNER JOIN match_combatant_statuses mcs ON (
          mcs.id = (
            SELECT mcs1.id FROM match_combatant_statuses AS mcs1
            WHERE mcs1.match_combatant_id = match_combatants.id
            ORDER BY mcs1.id DESC LIMIT 1
          )
        )
    SQL

  DELEGATE_METHODS_TO_ACCOUNT_COMBATANT = %i[
    account
    individual_power
  ].freeze

  DELEGATE_METHODS_TO_STATUS = %i[
    available?
    benched?
    deployed?
    knocked_out?
    queued?
    remaining_energy
    remaining_health
  ].freeze

  delegate(*DELEGATE_METHODS_TO_ACCOUNT_COMBATANT, to: :account_combatant)
  delegate(*DELEGATE_METHODS_TO_STATUS, to: :status)

  # @!attribute [r] account
  #   @return [Account]

  # @!method available?()
  #   @return [Boolean]

  # @!method benched?()
  #   @return [Boolean]

  # @!method deployed?()
  #   @return [Boolean]

  # @!attribute [r] individual_power
  #   @return [Integer]

  # @!method knocked_out?()
  #   @return [Boolean]

  # @!attribute [rw] match
  #   @return [Match]

  # @!method match_combatants_moves()
  #   @return [ActiveRecord::Relation<MatchCombatantsMove>]

  # @!attribute [rw] maximum_health
  #   @return [Integer]

  # @!method queued?()
  #   @return [Boolean]

  # @!attribute [r] remaining_energy
  #   @return [Integer]

  # @!attribute [r] remaining_health
  #   @return [Integer]

  # @!method statuses()
  #   @return [ActiveRecord::Relation<MatchCombatantStatus>]

  # @return [ActiveRecord::Relation<MatchCombatant>]
  def self.available
    availability = 'available'

    joins(AVAILABLE_JOIN).where(mcs: { availability: availability }).distinct
  end

  # @return [ActiveRecord::Relation<MatchCombatant>]
  def self.deployed
    joins(DEPLOYED_JOIN).where.not(mcs: { board_position_id: nil }).distinct
  end

  # @return [Player]
  def player
    @player ||= Player.where(account: account, match: match).select(:id).first
  end

  # @!attribute [r] player_id
  #   @return [Integer]

  delegate :id, to: :player, prefix: true

  # @return [BoardPosition]
  def position
    status.board_position
  end

  # @return [MatchCombatantStatus]
  def status
    statuses.order('id DESC').first
  end
end
