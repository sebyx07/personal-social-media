# frozen_string_literal: true

class VirtualComment
  class << self
    def comment_on_remote_post(remote_post_id, content, parent_comment_id: nil)
      subject_type = "RemotePost"

      create_comment(subject_type, remote_post_id, content, parent_comment_id)
    end

    def where(pagination_params: {}, subject_type:, subject_id:)
    end

    private
      def create_comment(subject_type, subject_id, content, parent_comment_id)
        VirtualCommentsService::CreateComment.new(subject_type, subject_id, content, parent_comment_id).call!
      end
  end
end
