# frozen_string_literal: true

class VirtualPostPresenter
  delegate :id, to: :@virtual_post

  def initialize(virtual_post)
    @virtual_post = virtual_post
  end

  def render
    {
      id: @virtual_post.id,
      created_at: @virtual_post.created_at,
      updated_at: @virtual_post.updated_at,
      content: @virtual_post.content,
      peer: PeerPresenter.new(@virtual_post.peer).render_low_data,
      reaction_counters: @virtual_post.reaction_counters.map do |reaction_counter|
        ReactionCounterPresenter.new(reaction_counter).render
      end
    }
  end

  def render_camelized
    render.deep_transform_keys! { |key| key.to_s.camelize(:lower) }
  end
end
