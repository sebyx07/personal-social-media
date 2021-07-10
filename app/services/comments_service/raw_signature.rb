# frozen_string_literal: true

module CommentsService
  class RawSignature
    def initialize(comment, peer)
      @comment = comment
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
          content: @comment.content,
          comment_type: @comment.comment_type,
          peer: PeerPresenter.new(@peer).render_in_signature
        }
      end
  end
end
