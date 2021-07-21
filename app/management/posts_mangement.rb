# frozen_string_literal: true

ActiveAdmin.register Post, namespace: :management do
  decorate_with ManagementPostDecorator
  menu label: "My Posts"
  actions :index, :show, :destroy

  filter :created_at
  filter :post_type, as: :select, collection: Post.post_types
  batch_action :destroy, false

  index do
    selectable_column
    column :content do |post|
      react_component("mountable/management-standard-post", { post: post.virtual_post_presenter.render })
    end

    column :id
    column :status
    column :type, sortable: :post_type do |post|
      post.post_type
    end

    actions
  end

  controller do
    def scoped_collection
      super.includes(*VirtualPostsService::WhereFinder::PRELOAD_ASSOCIATIONS_LOCALLY)
    end
  end
end
