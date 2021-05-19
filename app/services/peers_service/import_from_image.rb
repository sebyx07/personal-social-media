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
      return @peer if defined? @peer
      @peer = Peer.find_or_initialize_by(verify_key: params[:verify_key]).tap do |p|
        p.assign_attributes(params.merge(status: [:imported]))
      end
    end
  end
end
