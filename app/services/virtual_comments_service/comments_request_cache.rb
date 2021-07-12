# frozen_string_literal: true

module VirtualCommentsService
  class CommentsRequestCache
    attr_reader :comments, :top_cache
    def initialize(comments, top_cache: nil)
      @comments = comments
      @top_cache = top_cache
    end

    def sub_peers
      return @sub_peers if defined? @sub_peers

      if top_cache.present?
        return @sub_peers = top_cache.sub_peers
      end

      sub_peers_verify_keys = []
      comments.each do |comment|
        verify_key = get_verify_key_from_json(comment.dig(:peer, :verify_key))
        sub_peers_verify_keys << verify_key
      end

      @sub_peers = Peer.where(verify_key: sub_peers_verify_keys.uniq)
    end

    def cache_reactions
      return @cache_reactions if defined? @cache_reactions
      if top_cache.present?
        return @cache_reactions = top_cache.cache_reactions
      end

      CacheReaction.where()
    end

    private
      def get_verify_key_from_json(json)
        EncryptionService::EncryptedContentTransform.to_str(json)
      end
  end
end
