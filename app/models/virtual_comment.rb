# frozen_string_literal: true

class VirtualComment
  class << self
    def where(pagination_params: {}, subject_type:, subject_id:)
    end

    def create_comment(subject_type, subject_id, content, parent_comment_id, comment_type)
      VirtualCommentsService::CreateComment.new(subject_type, subject_id, content, parent_comment_id, comment_type).call!
    end

    def update_comment(cache_comment, content, comment_type)
      VirtualCommentsService::UpdateComment.new(cache_comment, content, comment_type).call!
    end
  end
end
