# frozen_string_literal: true

# Communicates changes in the match to the Match component of the client
class MatchesChannel < ApplicationCable::Channel
  def subscribed
    # @type [Match]
    return unless (match = Match.find(params['room']))

    player = Player.where(match: match, account: account).first

    broadcasting = "match_#{match.id}_player_#{player.id}"
    stream_from broadcasting

    response =
      Matches::GenerateObjectForClient.with(player: player).object

    ActionCable.server.broadcast(broadcasting, response)
  end
end
