# frozen_string_literal: true

module PostsService
  class IncrementViews
    attr_reader :ids
    def initialize(post: nil, posts: [])
      @ids = post.present? ? [post.id] : posts.map(&:id)
    end

    def call!
      return if ids.blank?
      Post.where(id: ids).update_all("views = views + 1")
    end
  end
end
