Rails.application.routes.draw do
  root to: 'pages#home'
  get '/browse', to: 'pages#browse'
  get '/creators', to: 'pages#creators'
  get '/about', to: 'pages#about'
  get '/contact', to: 'pages#contact'
end
