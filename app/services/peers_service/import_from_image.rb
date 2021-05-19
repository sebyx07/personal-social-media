# frozen_string_literal: true

module PeersService
  class ImportFromImage
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def call!
      peer.tap do |p|
        p.sync_from_whoami_remote!
        p.save!
      end
    end

    def peer
      @peer ||= Peer.new(params.merge(status: [:imported]))
    end
  end
end
