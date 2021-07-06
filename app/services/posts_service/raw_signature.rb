# frozen_string_literal: true

module PostsService
  class RawSignature
    def initialize(post, peer)
      @post = post
      @peer = peer
    end

    def hash
      attributes.hash
    end

    def attributes
      {
        content: @post.content,
        created_at: @post.created_at.as_json,
        peer: PeerPresenter.new(@peer).render_in_signature
      }
    end

    def ==(raw_signature)
      hash == raw_signature.hash
    end
  end
end
