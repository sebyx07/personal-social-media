# frozen_string_literal: true

module PeersService
  class SearchPeers
    attr_reader :search_params
    def initialize(search_params)
      @search_params = search_params
    end

    def call
      if search_params[:public_key].present?
        find_by_public_key
      end
    end

    private
      def find_by_public_key
        pk = EncryptionService::EncryptedContentTransform.to_str(search_params[:public_key].map(&:to_i))
        Peer.where(public_key: pk)
      end
  end
end
