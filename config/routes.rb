Rails.application.routes.draw do # rubocop:disable Layout/EndOfLine,Metrics/BlockLength
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Authenticatable routes by devise
  root 'home#index', as: 'home'
  get '/new_home', to: 'home#new_index'
  get '/:page', to: 'home#index_page'

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

  namespace :api, format: 'json' do # rubocop:disable Metrics/BlockLength
    namespace :v1 do # rubocop:disable Metrics/BlockLength
      resources :flashcards, constraints: { id: Patterns::ID_PATTERN } do
        member do
          get 'edit'
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
end
