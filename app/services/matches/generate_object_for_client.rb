# frozen_string_literal: true

module Matches
  # Contains the logic for assembling an object representing the entire state of
  # a [Match] to the client
  class GenerateObjectForClient < ApplicationService
    # @return [Hash, NilClass]
    attr_reader :object

    # @param player [Player]
    def initialize(player:)
      @player = player
    end

    def perform
      @object = {
        id: id,
        boardPositions: board_positions,
        combatants: combatants,
        events: events,
        players: players,
        turn: match.turn.turn
      }
    end

    private

    # @return [Player]
    attr_reader :player

    # @return [Account]
    def account
      player.account
    end

    # @return [Hash]
    def board_positions

      # @param position [BoardPosition]
      @match.board_positions.map do |position|
        {
          id: position.id.to_s,
          x: position.x,
          y: position.y
        }
      end
    end

    # @return [Array]
    def combatants
      @combatants ||=
        # @param combatant [MatchCombatant]
        match.combatants.map do |combatant|
          {
            id: combatant.id.to_s,
            moves: match_combatant_moves(combatant),
            name: combatant.combatant.name,
            playerId: combatant.player_id.to_s
          }.merge(match_combatant_status(combatant))
        end
    end

    def events
      @events ||=
        # @param event [MatchEvent]
        match.events.order('id ASC').map do |event|
          if event.category == "damage" &&
             event.match_combatant.player != player
            amount =
              (
                (
                  event.amount /
                  event.match_combatant.health.to_f
                ) * 100
              ).round
          else
            amount = event.amount
          end

          {
            id: event.id.to_s,
            amount: amount,
            boardPositionId: event.board_position_id&.to_s,
            category: event.category,
            createdAt: event.created_at,
            description: '',
            matchCombatantId: event.match_combatant_id&.to_s,
            property: event.property,
            status: event.status,
            turn: event.match_turn.turn
          }
        end
    end

    # @return [String]
    def id
      match.id.to_s
    end

    # @return [Match]
    def match
      @match ||= player.match
    end

    # @param match_combatant [MatchCombatant]
    # @return [Array<Hash>]
    def match_combatant_moves(match_combatant)
      return [] unless match_combatant.account == account

      # @param match_combatants_move [MatchCombatantsMove]
      match_combatant.match_combatants_moves.map do |match_combatants_move|
        # @type [Move]
        move = match_combatants_move.move
        {
          id: match_combatants_move.id.to_s,
          description: move.description,
          energyCost: move.energy_cost,
          isDiagonal: move.is_diagonal,
          name: move.name,
          range: move.range
        }
      end
    end

    # @param match_combatant [MatchCombatant]
    # @return [Hash]
    def match_combatant_status(match_combatant)
      status = match_combatant.status

      base = {
        boardPositionId: status.board_position_id&.to_s,
        isFriendly: false,
        statusEffects: []
      }.compact

      if match_combatant.player == player
        remaining_health =
          if status.remaining_health > 0
            status.remaining_health
          else
            0
          end

        return base.merge(
          availability: status.availability,
          defense: match_combatant.defense,
          isFriendly: true,
          maximumHealth: match_combatant.health,
          remainingHealth: remaining_health,
        )
      else
        remaining_health =
          if status.remaining_health > 0
            (status.remaining_health / match_combatant.health.to_f * 100).round
          else
            0
          end

        return base.merge(
          isFriendly: false,
          maximumHealth: 100,
          remainingHealth: remaining_health,
        )
      end

      base.merge(
        statusEffects: []
      )
    end

    # @return [Array]
    def players
      @players ||=
        # @param player [Player]
        match.players.map do |match_player|
          is_local_player = match_player.account_id == player.account_id

          {
            id: match_player.id.to_s,
            isLocalPlayer: is_local_player,
            name: match_player.name
          }
        end
    end
  end
end
