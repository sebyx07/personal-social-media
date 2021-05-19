# frozen_string_literal: true

module PeersService
  class BuildApiUrl
    attr_reader :peer
    def initialize(peer)
      @peer = peer
    end

    def call
      return "/api" if Rails.env.test?
      return "http://localhost:3000/api" if peer.domain_name == "localhost:3000" if Rails.env.development?
      "https://#{peer.domain_name}/api"
    end
  end
end
