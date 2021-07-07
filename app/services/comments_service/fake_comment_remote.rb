# frozen_string_literal: true

module CommentsService
  class FakeCommentRemote
    ATTRIBUTES = %i(
      id comment_type content sub_comments_count parent_comment_id subject_id subject_type
      created_at updated_at
    )

    def initialize(attributes)
      @attributes = attributes
    end

    def peer
      @peer ||= PeersService::FakePeerRemote.new(@attributes[:peer])
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
  end
end
