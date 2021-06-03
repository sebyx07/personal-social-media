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
      peer: PeerPresenter.new(@reaction.peer).render_low_data
    }
  end
end
