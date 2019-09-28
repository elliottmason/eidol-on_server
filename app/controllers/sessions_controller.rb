class SessionsController < ApplicationController
  def new
    Rails.logger.debug(cookies.signed[:account_id])
  end

  def create
    account = Account.find_by_email_address(params[:email_address])
    cookies.signed[:account_id] = { value: account.id, expires: 1.hour }

    Rails.logger.debug(cookies.signed[:account_id])

    redirect_to 'http://localhost:3000/matches/1'
  end
end