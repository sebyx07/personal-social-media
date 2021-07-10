# frozen_string_literal: true

module PeersService
  class SafeAvatar
    include ActionView::Helpers::AssetUrlHelper
    attr_reader :peer, :size
    def initialize(peer)
      @peer = peer
    end

    def url(size:)
      @size = size
      if peer.email_hexdigest.present? || peer.email.present?
        return gravatar
      end
      blank_avatar
    end

    def blank_avatar
      image_url("placeholders/avatar-placeholder.svg")
    end

    def gravatar
      PeersService::Gravatar.new(email_hexdigest: peer.email_hexdigest).url(size: size)
    end
  end
end
