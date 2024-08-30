require 'karafka/web'
require 'sidekiq/web'

Rails.application.routes.draw do
  mount Karafka::Web::App, at: '/karafka'
  mount Sidekiq::Web => "/sidekiq"

  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :customers, only: :show
  resources :films, only: [:index, :show, :create]
  resources :stores, only: [:index, :show]

  namespace :api do
    namespace :v1 do
      resources :films, only: [:index] do
        collection do
          get :narrow
        end
      end

      resources :customers, only: [:index] do
        get :timeline
        get :rentals
        get :archived_rentals
      end

      resources :stores, only: [:show] do
        resources :films, only: [:index] do
          get :rentals
          resources :rentals, only: [:create]
        end
        resources :audits, only: [:index]
      end
    end
  end

  get 'happynewyear', to: 'home#happy_new_year'
  get 'home', to: 'home#home'
end
