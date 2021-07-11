# frozen_string_literal: true

module CommentsService
  class RawSignature
    class InvalidRecordOwner < StandardError; end
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
          subject_type: subject_type,
          subject_id: @comment.subject_id,
          comment_type: @comment.comment_type,
          record_owner_public_key: record_owner_public_key,
          peer: PeerPresenter.new(@peer).render_in_signature
        }
      end

      def subject_type
        if %w(Post RemotePost).include?(@comment.subject_type)
          "Post"
        end
      end

      def record_owner_public_key
        if @comment.is_a?(Comment)
          Current.peer.public_key
        elsif @comment.is_a?(CacheComment)
          @comment.peer.public_key
        elsif @comment.is_a?(CommentsService::FakeCommentRemote)
          EncryptionService::EncryptedContentTransform.to_str(@comment.peer.public_key)
        else
          raise InvalidRecordOwner, @comment.class.name
        end
      end
  end
end
