# frozen_string_literal: true

class VirtualPostPresenter
  delegate :id, :created_at, to: :@virtual_post

  def initialize(virtual_post)
    @virtual_post = virtual_post
  end

  def render
    {
      id: id,
      created_at: created_at,
      updated_at: @virtual_post.updated_at,
      content: @virtual_post.content,
      peer: PeerPresenter.new(@virtual_post.peer).render_low_data,
      views: @virtual_post.views,
      comments_count: @virtual_post.comments_count,
      latest_comments: @virtual_post.latest_comments.map do |comment|
        CommentPresenter.new(comment).render_with_is_mine(@virtual_post.cache_comments)
      end,
      cache_comments: @virtual_post.cache_comments.map do |cache_comment|
        CommentPresenter.new(cache_comment).render_cache_comment
      end,
      reaction_counters: @virtual_post.reaction_counters.map do |reaction_counter|
        ReactionCounterPresenter.new(reaction_counter).render_with_has_reacted(@virtual_post.cache_reactions)
      end
    }
  end
end
