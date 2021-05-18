# frozen_string_literal: true

Rails.application.routes.draw do
  SettingsService::WebUrl.new.full_host.tap do |full_host|
    Rails.application.routes.default_url_options[:host] = full_host if full_host.present?
  end
  root to: "home#index"
  get "/whoami", to: "profiles#whoami"

  namespace :sessions, path: "" do
    get "/login", action: :login
    post "/login", action: :login_post

    get "/register", action: :register
    post "/register", action: :register_post
  end

  namespace :api do
    namespace :instance do
      post "/whoami", action: "whoami"
    end
  end
end
