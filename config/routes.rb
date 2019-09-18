# frozen_string_literal: true

Rails.application.routes.draw do
  resources :match_move_selections, only: %i[create]
  resources :matches, only: %i[show]
end
