# frozen_string_literal: true

class PostPresenter
  def initialize(post)
    @post = post
  end

  def render
    {
      id: @post.id,
      content: @post.content
    }
  end
end
