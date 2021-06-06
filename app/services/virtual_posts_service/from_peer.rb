# frozen_string_literal: true

module VirtualPostsService
  class FromPeer
    attr_reader :pagination_params, :peer_id, :post_type
    def initialize(pagination_params, post_type, peer_id)
      @pagination_params = pagination_params
      @post_type = post_type
      @peer_id = peer_id
    end

    def result
      api_client_request.tap do |req|
        req.run
        next unless req.valid?

        api_client_request.record = save_as_remote_posts!
      end
    end

    private
      def api_client_request
        return @api_client_request if defined? @api_client_request
        @api_client_request = HttpService::ApiClient.new(
          url: url,
          method: :post,
          body: body,
          peer: peer
        )
      end

      def body
        pagination_params.slice(:pagination, :post_type)
      end

      def url
        peer.api_url("/posts")
      end

      def peer
        @peer ||= Peer.find_by(id: peer_id)
      end

      def save_as_remote_posts!
        api_client_request.json[:posts].map do |post_json|
          handle_remote_post(post_json)
        end.tap do |remote_posts|
          ActiveRecord::Associations::Preloader.new.preload(remote_posts, preloaded_associations)
        end
      end

      def preloaded_associations
        WhereFinder::PRELOAD_ASSOCIATIONS_EXTERNALLY - %i(peer)
      end

      def handle_remote_post(post_json)
        post = RemotePost.find_or_initialize_by(peer: peer, remote_post_id: post_json[:id])
        return post if post.persisted?
        r_post_json = DateTime.parse(post_json[:created_at])
        created_at = r_post_json.future? ? r_post_json : 1.day.ago
        post.created_at = created_at

        post.tap(&:save!)
      end
  end
end
