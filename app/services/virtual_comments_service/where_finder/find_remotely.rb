# frozen_string_literal: true

module VirtualCommentsService
  class WhereFinder
    class FindRemotely
      class Error < StandardError; end
      attr_reader :subject, :pagination_params, :parent_comment_id
      delegate :peer, to: :subject

      def initialize(pagination_params, subject, parent_comment_id)
        @pagination_params = pagination_params
        @subject = subject
        @parent_comment_id = parent_comment_id
      end

      def results
        api_client_request.run
        return [] unless api_client_request.valid?
        api_client_request.json[:comments]
      end

      private
        def body
          {
            comments: {
              subject_id: subject_id,
              subject_type: subject_type,
              parent_comment_id: parent_comment_id
            }
          }.merge(pagination_params.slice(:pagination))
        end

        def api_client_request
          return @api_client_request if defined? @api_client_request
          @api_client_request = HttpService::ApiClient.new(
            url: url,
            method: :post,
            body: body,
            record: subject,
            peer: peer
          )
        end

        def url
          peer.api_url("/comments")
        end

        def subject_id
          if subject.is_a?(RemotePost)
            subject.remote_post_id
          end
        end

        def subject_type
          if subject.is_a?(RemotePost)
            "Post"
          end
        end
    end
  end
end
