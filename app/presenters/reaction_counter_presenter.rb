# frozen_string_literal: true

class ReactionCounterPresenter
  def initialize(reaction_counter)
    @reaction_counter = reaction_counter
  end

  def render
    {
      character: @reaction_counter.character,
      reactions_count: @reaction_counter.reactions_count
    }
  end

  def render_with_has_reacted(cache_reactions)
    char = @reaction_counter.character
    has_reacted = cache_reactions.detect { |r| r.character == char }.present?

    render.merge!(has_reacted: has_reacted)
  end
end
