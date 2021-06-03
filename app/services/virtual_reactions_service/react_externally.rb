# frozen_string_literal: true

module VirtualReactionsService
  class ReactExternally
    class Error < StandardError; end
    attr_reader :local_cache_record, :character, :cache_reaction
    delegate :peer, to: :local_cache_record

    def initialize(local_cache_record, character)
      @local_cache_record = local_cache_record
      @character = character
    end

    def call!
      @cache_reaction = CacheReaction.find_or_initialize_by(subject: local_cache_record, character: character, peer: local_cache_record.peer)
      return cache_reaction if cache_reaction.persisted?

      request.run

      return handle_valid_request if request.valid?

      raise Error, "unable to react"
    end

    private
      def handle_valid_request
        cache_reaction.remote_reaction_id = request.json.dig(:reaction, :id)

        cache_reaction.tap(&:save!)
      end

      def request
        @request ||= HttpService::ApiClient.new(
          url: peer.api_url("/reactions"),
          method: :post,
          body: body,
          peer: peer
        )
      end

      def body
        {
          reaction: {
            subject_id: subject_id,
            subject_type: subject_type,
            character: character
          }
        }
      end

      def subject_id
        if local_cache_record.is_a?(RemotePost)
          local_cache_record.remote_post_id
        end
      end

      def subject_type
        if local_cache_record.is_a?(RemotePost)
          "Post"
        end
      end
  end
end
