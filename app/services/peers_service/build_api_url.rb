# frozen_string_literal: true

module PeersService
  class BuildApiUrl
    attr_reader :peer
    def initialize(peer)
      @peer = peer
    end

    def call(url)
      return cleanse_url("/api" + url) if Rails.env.test?
      return cleanse_url("http://localhost:3000/api" + url) if peer.domain_name == "localhost:3000" if Rails.env.development?
      cleanse_url("https://#{peer.domain_name}/api" + url)
    end

    def cleanse_url(url)
      url.gsub("//", "/").gsub("/api/api/", "/api/")
    end
  end
end
