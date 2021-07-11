# frozen_string_literal: true

module PostsService
  class RawSignature
    def initialize(post, peer)
      @post = post
      @peer = peer
    end

    def hash
      HashDigest.digest3(attributes)
    end

    def ==(raw_signature)
      hash == raw_signature.hash
    end

    private
      def attributes
        {
          content: @post.content,
          created_at: @post.created_at.as_json,
          peer: PeerPresenter.new(@peer).render_in_signature
        }
      end
  end
end
