# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
  end

  def create
    account = Account.find_by_email_address(params[:email_address])
    cookies.signed[:account_id] = { value: account.id, expires: 3.days }

    match_id = Match.last.id
    redirect_to "http://localhost:3000/matches/#{match_id}"
  end
end
