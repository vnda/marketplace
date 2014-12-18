require 'sidekiq/web'

Rails.application.routes.draw do

  root 'stores#index'  
  mount Sidekiq::Web => '/sidekiq'
  resources :stores
  resources :ml_stocks, only: [:create]
  resources :vnda_stocks, only: [:create, :index]
  resources :status, only: [:index]
end
