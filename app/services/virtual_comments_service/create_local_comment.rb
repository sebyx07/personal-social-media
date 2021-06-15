# frozen_string_literal: true

module VirtualCommentsService
  class CreateLocalComment
    attr_reader :remote_record, :record, :content, :parent_comment_id, :cache_comment
    def initialize(remote_record, local_record, content, parent_comment_id)
      @remote_record = remote_record
      @local_record = local_record
      @content = content
      @parent_comment_id = parent_comment_id
    end

    def call!
      CacheComment.transaction do
        comment = Comment.create!(
          parent_comment_id: parent_comment_id,
          comment_counter: comment_counter,
          peer: Current.peer,
          comment_type: content.comment_type,
          content: content.saveable_content
        )

        @cache_comment = CacheComment.create!(
          peer: Current.peer,
          comment_type: content.comment_type,
          content: content.saveable_content,
          subject_type: remote_record.class.name,
          subject_id: remote_record.id,
          remote_id: comment.id
        )
      end

      cache_comment
    end

    def comment_counter
      return @comment_counter if defined? @comment_counter
      @comment_counter = record.comment_counter || CommentCounter.create!(subject: record)
    end
  end
end
