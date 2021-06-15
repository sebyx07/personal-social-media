# frozen_string_literal: true

module CommentsService
  class CreateComment
    class Error < StandardError; end
    attr_reader :content, :current_peer, :comment_params

    def initialize(comment_params, current_peer)
      @comment_params = comment_params
      @content = VirtualCommentsService::CommentContent.new(permitted_params: comment_params)
      @current_peer = current_peer
    end

    def call!
      validate_subject_type!
      attributes = {
        comment_counter: comment_counter,
        peer: current_peer,
        comment_type: comment_params[:comment_type],
        parent_comment_id: comment_params[:parent_comment_id]
      }
      attributes.merge!(content.saveable_content)

      Comment.create!(attributes)
    end

    private
      def record
        @record ||= subject_type.constantize.find_by(id: subject_id).tap do |record|
          raise Error, "subject not found #{subject_type} - #{subject_id}" if record.blank?
        end
      end

      def comment_counter
        @comment_counter ||= record.comment_counter || CommentCounter.create!(subject: record)
      end

      def validate_subject_type!
        raise Error, "invalid subject type" unless Comment::PERMITTED_SUBJECT_CLASSES.include?(subject_type)
      end

      def subject_type
        comment_params[:subject_type]
      end

      def subject_id
        comment_params[:subject_id]
      end
  end
end
