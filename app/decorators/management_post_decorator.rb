# frozen_string_literal: true

class ManagementPostDecorator < ApplicationDecorator
  decorates :post
  delegate_all
  def virtual_post
    @virtual_post ||= VirtualPost.new(post: model, peer: Current.peer, remote_post: model.remote_post)
  end

  def virtual_post_presenter
    @virtual_post_presenter ||= VirtualPostPresenter.new(virtual_post)
  end

  def name
    "Post ##{id}"
  end
end
