Rails.application.routes.draw do
  resources :matches, only: %i[show]
end
