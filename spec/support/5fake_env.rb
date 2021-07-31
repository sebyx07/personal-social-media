# frozen_string_literal: true

module FakeEnv
  def fake_env(env = "production")
    prev_env = Rails.env
    Rails.env = env.to_s
    yield

  ensure
    Rails.env = prev_env
  end
end
