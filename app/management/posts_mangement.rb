# frozen_string_literal: true

ActiveAdmin.register Post, namespace: :management do
  menu label: "My Posts"
  filter :created_at
  filter :post_type, as: :select, collection: Post.post_types
  batch_action :destroy, false

  index do
    selectable_column
    column :id
    column :status
    column :type, sortable: :post_type do |post|
      post.post_type
    end

    column :created_at
    actions
  end

  controller do
    def scoped_collection
      super
    end
  end
end
