class MatchesController < ApplicationController
  def show
    # must be a player in this match to see it

    @player = Player.first
    @match = Match.find(params[:id])
  end
end
