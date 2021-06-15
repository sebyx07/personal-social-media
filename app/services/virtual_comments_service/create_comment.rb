# frozen_string_literal: true

module VirtualCommentsService
  class CreateComment
    class Error < StandardError; end
    attr_reader :subject_type, :subject_id, :content, :parent_comment_id, :comment_type

    def initialize(subject_type, subject_id, content, parent_comment_id, comment_type)
      @subject_type = subject_type
      @subject_id = subject_id
      @content = content
      @parent_comment_id = parent_comment_id
      @comment_type = comment_type
    end

    def call!
      validate_subject_type!

      return handle_locally if is_local_record?
      handle_remotely
    end

    private
      def remote_record
        return @remote_record if defined? @remote_record

        @remote_record = subject_type.constantize.find_by(id: subject_id).tap do |record|
          raise Error, "remote_record not found #{subject_type} - #{subject_id}" if record.blank?
        end
      end

      def handle_locally
        CreateLocalComment.new(remote_record, local_record, content, parent_comment_id, comment_type).call!
      end

      def handle_remotely
        CreateCommentExternally.new(remote_record, content, parent_comment_id, comment_type).call!
      end

      def is_local_record?
        remote_record.peer_id == Current.peer.id
      end

      def local_record
        if remote_record.is_a?(RemotePost)
          remote_record.local_post
        end
      end

      def validate_subject_type!
        raise Error, "invalid subject type #{subject_type}" unless %w(RemotePost).include?(subject_type)
      end
  end
end
