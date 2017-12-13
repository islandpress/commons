Rails.application.routes.draw do
  default_url_options Rails.application.config.action_mailer.default_url_options

  root 'static_pages#home'
  get '/privacypolicy', to: 'static_pages#policy', as: :policy
  get '/about', to: 'static_pages#about', as: :about
  get '/demo1', to: 'static_pages#demo1', as: :demo1
  get '/demo2', to: 'static_pages#demo2', as: :demo2
  get '/demo3', to: 'static_pages#demo3', as: :demo3
  get '/demo4', to: 'static_pages#demo4', as: :demo4
  get '/demo5', to: 'static_pages#demo5', as: :demo5
  get '/demo6', to: 'static_pages#demo6', as: :demo6
  get '/demo7', to: 'static_pages#demo7', as: :demo7
  get '/demo8', to: 'static_pages#demo8', as: :demo8
  get '/demo9', to: 'static_pages#demo9', as: :demo9
  get '/demo10', to: 'static_pages#demo10', as: :demo10

  # External API routes
  namespace :api do
    namespace :v1 do
      get '/search', to: 'search#show', as: 'search'
      resources :users, only: %i(create update)
      resources :resources, only: %i(show create update)
      resources :networks, only: %i(index show create update) do
        namespace :relationships do
          resources :users, only: %i(index) do
            collection do
              patch '/', action: 'update'
              post '/', action: 'create'
              delete '/', action: 'destroy'
            end
          end
        end
      end
      resources :lists, only: %i(show create) do
        namespace :relationships do
          resources :items, only: %i(index) do
            collection do
              patch '/', action: 'update'
              post '/', action: 'create'
              delete '/', action: 'destroy'
            end
          end
        end
      end
    end
  end

  # Internal API routes
  concern :taggable do
    resources :tags, only: [:create]
  end
  get '/autocomplete/members', to: 'autocomplete#members', as: 'autocomplete_members'
  get '/autocomplete/lists/:current_resource', to: 'autocomplete#lists', as: 'autocomplete_lists'
  get '/autocomplete/lists_owners', to: 'autocomplete#list_owners', as: 'autocomplete_list_owners'

  # User-facing routes
  resources :search, only: [:new]
  get '/search', to: 'search#show', as: 'search'

  get '/profile', to: 'users/profile#edit', as: 'profile'
  patch '/profile', to: 'users/profile#update', as: 'update_profile'

  resources :users, only: [] do
    resources :api_keys
  end

  resources :list_items, only: [:create, :destroy]

  resources :resources, model_name: 'Resource', concerns: :taggable
  resources :lists, model_name: 'List', concerns: :taggable

  resources :networks, model_name: 'Network', concerns: :taggable do
    resources :members, only: [:index, :create, :destroy] do
      collection do
        post :join
        delete :leave
      end
      member do
        post :make_admin
        post :remove_admin
      end
    end
  end

  resource :s3_signature, only: [:show]

  devise_for :users

  # TODO: replace this with a check for admin user
  if Rails.env.development? || ENV['ENABLE_SIDEKIQ_ADMIN']
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end
end
