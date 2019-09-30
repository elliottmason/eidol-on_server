# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :account

    def connect
      self.account = find_account
    end

    protected

    # @return [Account]
    def find_account
      Account.find(cookies.signed[:account_id])
    rescue ActiveRecord::RecordNotFound
      reject_unauthorized_connection
    end
  end
end
