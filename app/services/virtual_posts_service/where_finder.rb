# frozen_string_literal: true

module VirtualPostsService
  class WhereFinder
    attr_reader :pagination_params, :peer_id
    def initialize(pagination_params, peer_id)
      @pagination_params = pagination_params
      @peer_id = peer_id
    end

    def results
      if peer_id.present?
        handle_for_peer_id
      end
    end

    private
      def handle_local_posts(posts)
        p = Current.peer
        posts.map { |post| VirtualPost.new(post: post, peer: p) }
      end

      def handle_remote_requests(requests)
        requests.select(&:valid?)
      end
  end
end
