# frozen_string_literal: true

puma_min_threads = ENV.fetch("MIN_THREADS") { 5 }.to_i
puma_max_threads = ENV.fetch("MAX_THREADS") { 5 }.to_i
rails_env = ENV.fetch("RAILS_ENV") { "development" }

threads(puma_min_threads, puma_max_threads)
is_deployed_remotely = %w[production].include?(rails_env)

if is_deployed_remotely
  puma_workers = ENV.fetch("WEB_CONCURRENCY") { Etc.nprocessors }.to_i
  workers(puma_workers)

  preload_app!

  rackup DefaultRackup
  environment "production"

  on_worker_boot do
    config = ActiveRecord::Base.configurations[rails_env]
    config["pool"] = puma_max_threads
    ActiveRecord::Base.establish_connection
  end
else
  workers(1)
  environment rails_env
end

port ENV.fetch("PORT") { 3000 }
