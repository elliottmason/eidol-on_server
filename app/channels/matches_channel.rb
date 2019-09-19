# frozen_string_literal: true

# Communicates changes in the match to the Match component of the client
class MatchesChannel < ApplicationCable::Channel
  def subscribed
    # @type [Match]
    return unless (match = Match.find(params['room']))

    broadcasting = "match_#{match.id}"
    stream_from broadcasting

    player = Player.first

    response =
      Matches::GenerateObjectForClient.with(match: match, player: player).object

    ActionCable.server.broadcast(broadcasting, response)
  end
end
