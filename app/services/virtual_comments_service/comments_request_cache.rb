# frozen_string_literal: true

module VirtualCommentsService
  class CommentsRequestCache
    attr_reader :json_comments, :top_cache, :remote_peer
    def initialize(json_comments, remote_peer, top_cache: nil)
      @json_comments = json_comments
      @remote_peer = remote_peer
      @top_cache = top_cache
    end

    def sub_peers
      return @sub_peers if defined? @sub_peers

      if top_cache.present?
        return @sub_peers = top_cache.sub_peers
      end

      sub_peers_verify_keys = []
      json_comments.each do |comment|
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

      characters = []
      comment_ids = []
      json_comments.each do |comment|
        comment_ids << comment[:id]

        comment[:reaction_counters].each do |cache_reaction|
          characters << cache_reaction[:character]
        end
      end

      @cache_reactions = CacheReaction.where(peer: remote_peer, character: characters, subject_id: comment_ids, subject_type: "Comment")
    end

    def cache_comments
      return @cache_comments if defined? @cache_comments
      if top_cache.present?
        @cache_comments = top_cache.cache_comments
      end

      remote_comment_ids = json_comments.map do |json_comment|
        json_comment[:id]
      end

      @cache_comments = CacheComment.where(peer: remote_peer, remote_comment_id: remote_comment_ids).to_a
    end

    private
      def get_verify_key_from_json(json)
        EncryptionService::EncryptedContentTransform.to_str(json)
      end
  end
end
