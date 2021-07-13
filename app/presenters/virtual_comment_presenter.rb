# frozen_string_literal: true

class VirtualCommentPresenter
  def initialize(virtual_comment)
    @virtual_comment = virtual_comment
  end

  def render
    {
      id: @virtual_comment.id,
      comment_type: @virtual_comment.comment_type,
      parent_comment_id: @virtual_comment.parent_comment_id,
      content: @virtual_comment.content,
      created_at: @virtual_comment.created_at,
      updated_at: @virtual_comment.updated_at,
      sub_comments_count: @virtual_comment.sub_comments_count,
      peer: PeerPresenter.new(@virtual_comment.peer).render_with_is_me,
      reaction_counters: @virtual_comment.reaction_counters.map do |reaction_counter|
        ReactionCounterPresenter.new(reaction_counter).render_with_has_reacted(@virtual_comment.cache_reactions)
      end
    }
  end
end
