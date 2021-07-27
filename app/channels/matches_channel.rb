# frozen_string_literal: true

# Communicates changes in the match to the Match component of the client
class MatchesChannel < ApplicationCable::Channel
  def self.broadcast_match(match)
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
    return unless (match = Match.find(params['room']))

    player = Player.where(match: match, account: account).first

    broadcasting = "match_#{match.id}_player_#{player.id}"
    stream_from broadcasting

    match_json =
      Matches::GenerateObjectForClient.with(player: player).object
    response_json = { match: match_json, kind: 'initial' }
    ActionCable.server.broadcast(broadcasting, response_json)
  end
end
