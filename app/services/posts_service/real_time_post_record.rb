# frozen_string_literal: true

module PostsService
  class RealTimePostRecord
    attr_reader :post
    def initialize(post)
      @post = post
    end

    def can_propagate_realtime?
      true
    end

    def json
      return { id: post.id } if post.destroyed?
      VirtualPost.new(post: post, remote_post: post.remote_post, peer: Current.peer).yield_self do |virtual_post|
        VirtualPostPresenter.new(virtual_post).render
      end
    end

    def virtual_id
    end

    def type
      "RemotePost"
    end
  end
end
