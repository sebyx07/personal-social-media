# frozen_string_literal: true

module CommentsService
  class FakeCommentRemote
    attr_reader :request_helper_cache, :parent_record
    ATTRIBUTES = %i(
      id comment_type content sub_comments_count parent_comment_id subject_id subject_type
      created_at updated_at
    )

    def initialize(attributes, request_helper_cache, parent_record)
      @attributes = attributes
      @request_helper_cache = request_helper_cache
      @parent_record = parent_record
    end

    def peer
      return @peer if defined? @peer
      peer = PeersService::FakePeerRemote.new(@attributes[:peer])

      @peer = PeersService::RemotePeerWithFriendship.get_from_cache(request_helper_cache, peer)
    end

    ATTRIBUTES.each do |attr|
      define_method attr do
        @attributes[attr]
      end
    end

    def reaction_counters
      @reaction_counters ||= @attributes[:reaction_counters].map do |reaction_counter|
        ReactionCountersService::FakeReactionCounter.new(reaction_counter)
      end
    end

    def raw_signature
      @raw_signature ||= CommentsService::RawSignature.new(self, peer)
    end

    def cache_comment
      @cache_comment ||= CommentsService::GetCacheCommentIdFromCache.new(request_helper_cache, parent_record, self).call
    end
  end
end
