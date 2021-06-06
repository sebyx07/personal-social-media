# frozen_string_literal: true

puma_min_threads = ENV.fetch("MIN_THREADS", 5).to_i
puma_max_threads = ENV.fetch("MAX_THREADS", 5).to_i
rails_env = ENV.fetch("RAILS_ENV", "development")

threads(puma_min_threads, puma_max_threads)

port ENV.fetch("PORT", 3000)
environment rails_env
