# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "home#index"

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
