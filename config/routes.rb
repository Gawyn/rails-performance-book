Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :stores, only: [:show]

  namespace :api do
    namespace :v1 do
      resources :films, only: [:index] do
        collection do
          get :lean
        end
      end

      resources :customers, only: [:index]
    end
  end
end
