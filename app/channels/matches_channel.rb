# frozen_string_literal: true

# Communicates changes in the match to the Match component of the client
class MatchesChannel < ApplicationCable::Channel
  # @param match [Match]
  # @return [NilClass]
  def self.broadcast_match(match)
    # @param player [Player]
    match.players.each do |player|
      broadcasting = "match_#{match.id}_player_#{player.id}"
      match_json =
        Matches::GenerateObjectForClient.with(player: player).object
      response_json = { match: match_json, kind: 'update' }
      ActionCable.server.broadcast(broadcasting, response_json)
    end
  end

  def subscribed
    Rails.logger.debug(params.inspect)
    # @type [Match]
    return unless (match = Match.find(params['room']))

    # @type [Player]
    player = Player.where(match: match, account: account).first

    broadcasting = "match_#{match.id}_player_#{player.id}"
    stream_from broadcasting

    match_json =
      Matches::GenerateObjectForClient.with(player: player).object
    response_json = { match: match_json, kind: 'initial' }
    ActionCable.server.broadcast(broadcasting, response_json)
  end
end
