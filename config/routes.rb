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
        member do
          get 'edit'
        end
        collection do
          get 'search'
          get 'global_search'
        end
      end
      get 'current_user', to: 'current_user#index'
      # The ImagesController identifies resources by the FlashcardMaster.
      # IDs of the image must therefore be IDs of the FlashcardMaster.
      resources :images, only: %i[update destroy], constraints: { id: Patterns::ID_PATTERN } do
        member do
          post 'create'
        end
      end
      resources :results, only: %i[show], constraints: { id: Patterns::ID_PATTERN } do
        member do
          post 'answer'
          get 'latest_result'
        end
      end
    end
  end
end
