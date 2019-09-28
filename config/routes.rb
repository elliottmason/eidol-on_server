# frozen_string_literal: true

Rails.application.routes.draw do
  get 'sign_in', to: 'sessions#new', as: 'sign_in'
  post 'sign_in', to: 'sessions#create'

  resources :match_move_selections, only: %i[create]
end
