Rails.application.routes.draw do
  # Authenticatable routes by devise
  root 'home#index', as: 'home'

  devise_for :users, path: '',
                     path_names: {
                       sign_in: 'login',
                       sign_out: 'logout',
                       registration: 'signup'
                     },
                     controllers: {
                       sessions: 'users/sessions',
                       registrations: 'users/registrations'
                     }

  namespace :api, format: 'json' do
    namespace :v1 do
      resources :word_books, constraints: { id: Patterns::ID_PATTERN } do
        member do
          get 'edit'
          get 'answer'
        end
        collection do
          get 'search'
          get 'global_search'
        end
      end
      get 'health', to: 'health#index'
      get 'current_user', to: 'current_user#index'
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
