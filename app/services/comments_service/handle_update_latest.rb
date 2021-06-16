# frozen_string_literal: true

module CommentsService
  class HandleUpdateLatest
    LIMIT = 3
    attr_reader :comment

    def initialize(comment)
      @comment = comment
    end

    def call!
      return handle_sub_comment if comment.parent_comment_id.present?
      comment.is_latest = true

      return if latest_comments.size < LIMIT

      comments_which_need_updated = latest_comments[LIMIT - 1..-1]
      return if comments_which_need_updated.blank?
      Comment.where(id: comments_which_need_updated.map(&:id)).update_all(is_latest: false)
    end

    private
      def handle_sub_comment
        comment.is_latest = false
      end

      def latest_comments
        @latest_comments ||= comment.comment_counter.latest_comments.order(id: :desc)
      end
  end
end
