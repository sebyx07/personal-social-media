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
end
