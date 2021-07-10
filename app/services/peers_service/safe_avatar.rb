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
      if can_render_gravatar?
        return gravatar
      end
      blank_avatar
    end

    private
      def blank_avatar
        image_url("placeholders/avatar-placeholder.svg")
      end

      def gravatar
        gravatar_options = {}
        if peer.respond_to?(:email_hexdigest)
          gravatar_options[:email_hexdigest] = peer.email_hexdigest
        elsif peer.respond_to?(:email)
          gravatar_options[:email] = peer.email
        end

        PeersService::Gravatar.new(**gravatar_options).url(size: size)
      end

      def can_render_gravatar?
        peer.try(:email_hexdigest).present? || peer.try(:email).present?
      end
  end
end
