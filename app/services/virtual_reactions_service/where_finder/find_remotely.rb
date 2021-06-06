# frozen_string_literal: true

module VirtualReactionsService
  class WhereFinder
    class FindRemotely
      class Error < Exception; end
      attr_reader :cache_record, :pagination_params
      delegate :peer, to: :cache_record

      def initialize(pagination_params, cache_record)
        @pagination_params = pagination_params
        @cache_record = cache_record
      end

      def results
        api_client_request.run
        return [] unless api_client_request.valid?
        api_client_request.json[:reactions]
      end

      private
        def body
          {
            reactions: {
              subject_id: subject_id,
              subject_type: subject_type
            }
          }.merge(pagination_params.slice(:pagination))
        end

        def api_client_request
          return @api_client_request if defined? @api_client_request
          @api_client_request = HttpService::ApiClient.new(
            url: url,
            method: :post,
            body: body,
            record: cache_record,
            peer: peer
          )
        end

        def url
          peer.api_url("/reactions")
        end

        def subject_id
          if cache_record.is_a?(RemotePost)
            cache_record.remote_post_id
          end
        end

        def subject_type
          if cache_record.is_a?(RemotePost)
            "Post"
          end
        end
    end
  end
end
