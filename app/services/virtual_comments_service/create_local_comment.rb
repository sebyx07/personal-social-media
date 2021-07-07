# frozen_string_literal: true

module VirtualCommentsService
  class CreateLocalComment
    attr_reader :remote_record, :local_record, :content, :parent_comment_id, :cache_comment, :comment_type, :comment
    def initialize(remote_record, local_record, content, parent_comment_id, comment_type)
      @remote_record = remote_record
      @local_record = local_record
      @content = content
      @parent_comment_id = parent_comment_id
      @comment_type = comment_type
    end

    def call!
      CacheComment.transaction do
        @comment = Comment.new(
          parent_comment_id: parent_comment_id,
          comment_counter: comment_counter,
          peer: Current.peer,
          comment_type: comment_type,
          content: content.saveable_content,
        )
        comment.signature = signature
        comment.save!

        @cache_comment = CacheComment.create!(
          peer: Current.peer,
          comment_type: comment_type,
          content: content.saveable_content,
          subject_type: local_record.class.name,
          subject_id: local_record.id,
          remote_comment_id: comment.id,
          remote_parent_comment_id: parent_comment_id
        )
      end

      cache_comment
    end

    def comment_counter
      return @comment_counter if defined? @comment_counter
      @comment_counter = local_record.comment_counter || CommentCounter.create!(subject: local_record)
    end

    def signature
      CommentsService::JsonSignature.new(comment).call_raw_str
    end
  end
end
