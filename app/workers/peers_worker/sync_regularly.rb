# frozen_string_literal: true

module PeersWorker
  class SyncRegularly < ApplicationWorker
    include WorkersService::RandomScheduled

    def random_delay
      24.hours
    end

    def random_perform
      SyncService::SyncPeersRegularly.new.tap do |ping_peers|
        ping_peers.call!
      end
    end
  end
end
