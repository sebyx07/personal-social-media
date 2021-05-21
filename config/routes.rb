# frozen_string_literal: true

Rails.application.routes.draw do
  SettingsService::WebUrl.new.full_host.tap do |full_host|
    Rails.application.routes.default_url_options[:host] = full_host if full_host.present?
  end
  root to: "home#index"
  get "/whoami", to: "profiles#whoami"

  resources :peers, only: %i(index show create update destroy)

  namespace :sessions, path: "" do
    get "/login", action: :login
    post "/login", action: :login_post

    get "/register", action: :register
    post "/register", action: :register_post
  end

  namespace :api, defaults: { format: :json } do
    namespace :instance do
      post "/whoami", action: :whoami
      post "/sync", action: :sync
      post "/update_relationship", action: :update_relationship
    end
  end

  constraints LoggedInConstraint do
    if DeveloperService::IsEnabled.is_enabled?
      mount RailsAdmin::Engine => "/admin", as: "rails_admin"
      mount Sidekiq::Web => "/sidekiq"
    end
  end
end
