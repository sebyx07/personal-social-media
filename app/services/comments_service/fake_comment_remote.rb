# frozen_string_literal: true

module CommentsService
  class FakeCommentRemote
    ATTRIBUTES = %i(id comment_type content sub_comments_count)

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
  end
end
