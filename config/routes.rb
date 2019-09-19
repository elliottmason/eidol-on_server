# frozen_string_literal: true

Rails.application.routes.draw do
  resources :match_move_selections, only: %i[create]
end
