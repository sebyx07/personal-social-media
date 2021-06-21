# frozen_string_literal: true

RailsServerMonitor.config do |c|
  c.ignore_urls = [
    /sidekiq/,
    /admin/,
    /pghero/,
    /system-information/
  ]
end
