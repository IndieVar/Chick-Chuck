# frozen_string_literal: true

require 'sidekiq/web'

class AdminConstraint
  def matches?(request)
    request.env['warden'].user(:admin).present?
  end
end

Rails.application.routes.default_url_options[:host] =
  Rails.env.production? ? 'http://chick-chuck.com' : 'localhost:3000'
Rails.application.routes.draw do
  # WWW redirect
  match '(*any)',
        to: redirect(subdomain: ''),
        via: :all,
        constraints: { subdomain: 'www' }
  # 404 old pages to remove!
  get '/uk', to: redirect('/404')
  get '/uk/*other', to: redirect('/404')
  scope '(:locale)', locale: /#{I18n.available_locales.join('|')}/ do
    # 404
    get '404', to: 'errors#page_not_found'
    # 404 old pages to remove!
    # get "/contents/*other", to: redirect('/404')
    # get "/news/*other", to: redirect('/404')
    # get "/trucks/*other", to: redirect('/404')
    # Root path
    root to: 'main#index'
    # Sitemap
    get 'sitemap.xml', to: 'main#sitemap', format: 'xml', as: :sitemap
    # Robots
    get 'robots.txt',  to: 'main#robots',  format: 'txt', as: :robots
    # Favicon
    get 'favicon.png', to: 'main#favicon', format: 'png', as: :favicon
    # Cookies
    get 'cookies', to: 'main#cookies', as: :cookies, defaults: { format: 'turbo_stream' }

    # --- Content ---

    # Users
    resources :users, only: %i[index show], controller: 'users/users', path: 'carriers' do
      get '/modal',         to: 'users/users#modal',                  as: 'modal'
      get '/contacts',      to: 'users/users#contacts',               as: 'contacts'
    end

    # Products
    resources :products, only: %i[index show], controller: 'contents/products'
    get 'seller/:user_id', to: 'contents/products#user_products', as: 'user_products'

    # Calculator
    resource :calculator, only: %i[show], controller: 'contents/calculators' do
      get '/company/:company_id/calculator', to: 'contents/calculators#company_calculator', as: 'company'
    end

    # Moving preparation
    get '/moving_preparation', to: 'contents/moving_preparation#index', as: 'moving_preparation'

    # Comments
    resources :comments, only: %i[new edit create update destroy], controller: 'feedbacks/comments' do
      resources :comments, only: %i[new edit create update destroy], controller: 'feedbacks/comments'
    end

    # About service
    get 'about', to: 'contents/about#index', as: 'about'

    # Feedbacks
    resources :feedbacks, only: %i[index create edit update], controller: 'contents/feedbacks'

    # News content
    resources :news, only: %i[show index], controller: 'contents/news' do
      resources :comments, only: %i[new edit create update destroy], controller: 'feedbacks/comments'
    end

    # --- End of content ---

    # Admins
    devise_for :admins, controllers: { registrations: 'admins/registrations' }, skip: %i[registrations confirmations]
    as :admin do
      get 'admins/edit',  to: 'admins/registrations#edit',    as: 'edit_admin_registration'
      put 'admins',       to: 'admins/registrations#update',  as: 'admin_registration'
      namespace :admins, constraints: AdminConstraint.new do
        # Analytics
        mount ActiveAnalytics::Engine => '/analytics'
        # Sidekiq
        mount Sidekiq::Web => '/sidekiq'
        resources :categories, except: %i[show], controller: 'catalog/categories' do
          resources :things, except: %i[show], controller: 'catalog/things'
        end
        resources :news, except: %i[show]
        resources :languages, except: %i[index show]
        resources :districts, except: %i[show] do
          resources :cities
        end
        resource :dashboard, only: :show do
          get :users
        end
        post '/publish/news/:id', to: 'news#publish', as: 'publish_news'
      end
    end

    # Companies
    devise_for :companies, controllers: { registrations: 'companies/registrations' }
    namespace :companies do
      resources :prices,     only: %i[index create update]
      resource  :calculator, only: %i[create update]
      resource  :gallery,    only: %i[show create]
      get  '/dashboard',                to: 'dashboard#index',              as: 'dashboard'
      get  '/profile',                  to: 'profiles#profile',             as: 'edit_profile'
      put  '/profile',                  to: 'profiles#profile_update',      as: 'profile'
      get  '/company_info',             to: 'profiles#company_info',        as: 'edit_company_info'
      put  '/company_info',             to: 'profiles#company_info_update', as: 'company_info'
    end

    # Clients
    devise_for :clients, controllers: { registrations: 'clients/registrations' }, skip: :omniauth_callbacks
    namespace :clients do
      resource :profile, only: %i[edit update]
      get '/dashboard', to: 'dashboard#index', as: 'dashboard'
    end

    # Users
    namespace :users do
      resources :favorites, only: %i[index create destroy]
      resources :products, except: %i[show] do
        post '/publish',      to: 'products#publish',             as: 'publish'
        post '/mark_as_sold', to: 'products#mark_as_sold',        as: 'mark_as_sold'
      end
      # Email subscribers
      resources :mailers, only: [:create]
    end

    # Reviews
    resources :reviews, only: %i[new create edit update], controller: 'feedbacks/reviews'

    # Carrierwave attachments
    namespace :carrierwave do
      resources :images, only: %i[show destroy]
    end

    # Rooms
    resources :rooms, only: %i[index show create], param: :title, controller: 'feedbacks/rooms' do
      resources :messages, only: %i[edit update create destroy], controller: 'feedbacks/messages'
    end

    # Notifications
    resources :notifications, only: [:index], controller: 'feedbacks/notifications'
  end

  # Devise with omniauth_callbacks
  devise_for :clients, only: :omniauth_callbacks, controllers: { omniauth_callbacks: 'clients/omniauth_callbacks' }
end
