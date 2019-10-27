# frozen_string_literal: true

Rails.application.routes.draw do
  root to: redirect('sign_in', status: 302)
  get 'sign_in', to: 'sessions#new', as: 'sign_in'
  post 'sign_in', to: 'sessions#create'

  resources :match_combatant_deployments, only: %i[create]
  resources :match_move_selections, only: %i[create]
end
