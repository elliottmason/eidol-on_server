# frozen_string_literal: true

class Player < ApplicationRecord
  belongs_to :account
  belongs_to :match
  has_many :statuses, class_name: 'PlayerStatus'
end
