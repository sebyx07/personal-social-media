# frozen_string_literal: true

Rails.application.routes.draw do
  SettingsService::WebUrl.new.full_host.tap do |full_host|
    Rails.application.routes.default_url_options[:host] = full_host if full_host.present?
  end

  def reactable
    resources :reactions, only: %i(index create) do
      collection do
        delete "/", action: :destroy
      end
    end
  end

  root to: "home#index"

  get "/whoami", to: "profiles#whoami"

  resource :profile, only: %i(edit update) do
    get "/setup-recovery", action: :setup_recovery
    post "/setup-recovery", action: :setup_recovery_post
  end

  resources :peers, only: %i(index show create update destroy) do
    collection do
      post "/search", action: :search
    end
  end
  resources :posts, only: %i(index new create show update destroy edit) do
    reactable

    resources :comments, only: %i(index create destroy update) do
      reactable
    end
  end

  resources :comments, only: %i(destroy update)

  resources :notifications, only: %i(index create update destroy) do
    collection do
      post "/mark_all_as_seen", action: :mark_all_as_seen
    end

    member do
      post "/trigger_event", action: :trigger_event
    end
  end

  resources :uploads, only: :create

  namespace :sessions, path: "" do
    get "/login", action: :login
    post "/login", action: :login_post

    get "/register", action: :register
    post "/register", action: :register_post

    delete "/logout", action: :logout
  end

  namespace :api, defaults: { format: :json } do
    namespace :instance do
      post "/whoami", action: :whoami
      post "/sync", action: :sync
      post "/update_relationship", action: :update_relationship
    end

    namespace :posts do
      post "/", action: :index
      post "/:id", action: :show
    end

    namespace :remote_posts do
      post "/", action: :create
      delete "/:id", action: :destroy
    end

    namespace :reactions do
      post "/", action: :index
      delete "/:id", action: :destroy
    end

    namespace :comments do
      post "/", action: :index
      patch "/:id", action: :update
      delete "/:id", action: :destroy
    end
  end

  constraints LoggedInConstraint do
    mount RailsServerMonitor::Engine => "/system-information"

    if DeveloperService::IsEnabled.is_enabled?
      mount RailsAdmin::Engine => "/admin", as: "rails_admin"
      mount Sidekiq::Web => "/sidekiq"
      mount PgHero::Engine, at: "/pghero"
    end
  end
end
