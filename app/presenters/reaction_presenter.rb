# frozen_string_literal: true

class ReactionPresenter
  def initialize(reaction)
    @reaction = reaction
  end

  def render
    {
      id: @reaction.id,
      subject_id: @reaction.subject_id,
      subject_type: @reaction.subject_type,
      character: @reaction.character,
      created_at: @reaction.created_at,
      peer: PeerPresenter.new(@reaction.peer).render_low_data
    }
  end

  def render_cache_reaction
    {
      id: @reaction.remote_reaction_id,
      subject_id: @reaction.subject_id,
      subject_type: @reaction.subject_type,
      character: @reaction.character,
      created_at: @reaction.created_at,
      peer: PeerPresenter.new(@reaction.peer).render_low_data
    }
  end
end
