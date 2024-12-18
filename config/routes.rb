# config/routes.rb

Rails.application.routes.draw do
  # Custom routes for the game
  get 'new', to: 'games#new', as: 'new_game'      # Route for the new action with the named path helper
  post 'score', to: 'games#score'                  # Route for the score action

  # Reveal health status on /up
  get "up" => "rails/health#show", as: :rails_health_check
end
