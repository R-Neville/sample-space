Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get '/browse', to: 'pages#browse'
  get '/creators', to: 'pages#creators'
  get '/about', to: 'pages#about'
  get '/contact', to: 'pages#contact'
  get '/profile', to: 'profile#index'
  get '/profile/downloads', to: 'profile#downloads'
  get '/profile/likes', to: 'profile#likes'
  get '/profile/wishlist', to: 'profile#wishlist'
end
