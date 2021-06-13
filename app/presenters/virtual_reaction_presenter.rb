# frozen_string_literal: true

class VirtualReactionPresenter
  def initialize(virtual_reaction)
    @virtual_reaction = virtual_reaction
  end

  def render
    {
      id: @virtual_reaction.id,
      created_at: @virtual_reaction.created_at,
      character: @virtual_reaction.character,
      subject_id: @virtual_reaction.subject_id,
      subject_type: @virtual_reaction.subject_type,
      peer: PeerPresenter.new(@virtual_reaction.peer).render_low_data
    }
  end
end
