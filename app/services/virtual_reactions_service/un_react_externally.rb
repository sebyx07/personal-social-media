# frozen_string_literal: true

module VirtualReactionsService
  class UnReactExternally
    class Error < StandardError; end
    attr_reader :local_cache_record, :character
    delegate :peer, to: :local_cache_record

    def initialize(local_cache_record, character)
      @local_cache_record = local_cache_record
      @character = character
    end

    def call!
      raise Error, "cache reaction not found" if cache_reaction.blank?
      cache_reaction.destroy

      request.run_with_retry_in_background
    end

    def cache_reaction
      @cache_reaction ||= CacheReaction.find_by(subject: local_cache_record, character: character, peer: local_cache_record.peer)
    end

    def request
      @request ||= HttpService::ApiClient.new(
        url: peer.api_url("/reactions/#{cache_reaction.remote_reaction_id}"),
        method: :delete,
        peer: peer
      )
    end
  end
end
