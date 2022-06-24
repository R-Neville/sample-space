Rails.application.routes.draw do
  devise_for :users
  
  # Pages controller
  root to: 'pages#home'
  get '/browse', to: 'pages#browse'
  get '/about', to: 'pages#about'
  get '/contact', to: 'pages#contact'

  # Profile controller
  get '/profile', to: 'profile#index'
  get '/profile/uploads', to: 'profile#uploads'
  get '/profile/downloads', to: 'profile#downloads'
  get '/profile/likes', to: 'profile#likes'
  get '/profile/wishlist', to: 'profile#wishlist'

  # Samples controller
  get '/upload', to: 'samples#new'
  post '/upload', to: 'samples#create'
  get '/download/:id', to: 'samples#download', as: 'download'
  get '/samples/:id', to: 'samples#show', as: 'show_sample'
  get '/samples/:id/edit', to: 'samples#edit', as: 'edit_sample'
  patch '/samples/:id/edit', to: 'samples#update'
  delete '/samples/:id', to: 'samples#destroy', as: 'delete_sample'

  # Creators controller
  get '/creators', to: 'creators#index'
  get '/creators/:username', to: 'creators#show', as: 'creator'

  # Tags controller
  get '/tags', to: 'tags#index'
  get '/tags/:tag', to: 'tags#show', as: 'show_tag'
end
