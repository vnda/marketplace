require 'sidekiq/web'

Rails.application.routes.draw do

  root 'stores#index'  
  mount Sidekiq::Web => '/sidekiq'
  resources :stores
  
end
