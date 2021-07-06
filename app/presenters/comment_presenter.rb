# frozen_string_literal: true

class CommentPresenter
  def initialize(comment)
    @comment = comment
  end

  def render
    {
      id: @comment.id,
      comment_type: @comment.comment_type,
      parent_comment_id: @comment.parent_comment_id,
      subject_id: @comment.subject_id,
      subject_type: @comment.subject_type,
      content: @comment.content,
      created_at: @comment.created_at,
      updated_at: @comment.updated_at,
      sub_comments_count: @comment.sub_comments_count,
      peer: PeerPresenter.new(peer).render_low_data,
      reaction_counters: @comment.reaction_counters.map do |reaction_counter|
        ReactionCounterPresenter.new(reaction_counter).render
      end
    }
  end

  def render_cache_comment
    {
      id: @comment.remote_comment_id,
      comment_type: @comment.comment_type,
      parent_comment_id: @comment.remote_parent_comment_id,
      subject_id: @comment.subject_id,
      subject_type: @comment.subject_type,
      content: @comment.content,
      created_at: @comment.created_at,
      updated_at: @comment.updated_at,
      peer: PeerPresenter.new(@comment.peer).render_low_data
    }
  end

  def render_locally(cache)
    @cache = cache
    render.merge({
      is_mine: Current.peer == @comment.peer
    })
  end

  def peer
    return @peer if defined? @peer
    return @peer = @comment.peer unless @cache

    local_peer = @cache.sub_peers.detect do |peer|
      peer == @comment.peer
    end

    @peer = PeersService::RemoteFakePeerValidator.new(local_peer, @comment.peer)
  end
end
