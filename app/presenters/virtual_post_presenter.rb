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
      reaction_counters: @virtual_post.reaction_counters.map do |reaction_counter|
        ReactionCounterPresenter.new(reaction_counter).render
      end,
      cache_reactions: @virtual_post.cache_reactions.map do |cache_reaction|
        ReactionPresenter.new(cache_reaction).render_cache_reaction
      end
    }
  end
end
