# frozen_string_literal: true

class SessionsController < ActionController::Base
  skip_forgery_protection

  def create
    if (account = find_account_for_create)
      cookies.signed[:account_id] = { value: account.id, expires: 31.days }
      render json: {
        account: { id: account.id.to_s, username: account.username }
      }
    else
      head :unauthorized
    end
  end

  private

  def find_account_for_create
    find_existing_session ||
      Account.find_or_create_by(
        email_address: params_for_create[:email_address]
      )
  end

  def find_existing_session
    return unless (account_id = cookies.signed[:account_id])

    Account.find_by(id: account_id)
  end

  def params_for_create
    params.require(:session).permit(:email_address)
  end
end
