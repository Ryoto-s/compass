Rails.application.routes.draw do # rubocop:disable Layout/EndOfLine,Metrics/BlockLength
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Authenticatable routes by devise
  root 'home#index', as: 'home'
  get '/new_home', to: 'home#new_index'
  get '/home/:page', to: 'home#index_page'
  get 'health', to: 'health#index'

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
      resources :flashcards, constraints: { id: Patterns::ID_PATTERN } do
        collection do
          get 'search'
          get 'global_search'
        end
        resource :images, only: %i[create update destroy]
        resource :results, only: %i[show update] do
          collection do
            post 'answer'
            get 'latest_result'
          end
        end
        resource :favourites, only: %i[create destroy]
      end
    end
  end
  # Handle invalid request URL
  match '*unmatched', to: 'not_found#handle_routing_error', via: :all
end
