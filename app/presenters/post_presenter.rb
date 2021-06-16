# frozen_string_literal: true

class PostPresenter
  def initialize(post)
    @post = post
  end

  def render
    {
      id: @post.id,
      content: @post.content,
      post_type: @post.post_type,
      created_at: @post.created_at,
      updated_at: @post.updated_at,
      views: @post.views,
      comments_count: @post.comments_count,
      reaction_counters: @post.reaction_counters.map do |reaction_counter|
        ReactionCounterPresenter.new(reaction_counter).render
      end
    }
  end
end
