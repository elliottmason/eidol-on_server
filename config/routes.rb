# frozen_string_literal: true

Rails.application.routes.draw do
  resources :match_combatant_deployments, only: %i[create]
  resources :match_move_selections, only: %i[create]

  resources :sessions, only: %i[create]
end
