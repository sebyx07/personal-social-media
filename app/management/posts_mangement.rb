# frozen_string_literal: true

ActiveAdmin.register Post, namespace: :management do
  decorate_with ManagementPostDecorator
  searchable_select_options(scope: -> { scoped_collection }, text_attribute: :name, filter: ->(term, scope) {
    next scope.ransack(name_cont_all: term.split(" ")).result if term.size < 6
    scope.search_by_name(term)
  })

  menu label: "My Posts", priority: 0
  actions :index, :show, :destroy

  filter :created_at
  filter :post_type, as: :select, collection: Post.post_types
  batch_action :destroy, false

  index do
    selectable_column
    column :content do |post|
      react_component("mountable-in-management/management-standard-post", { post: post.virtual_post_presenter.render })
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
      return super if action_name == "all_options"

      super.includes(*VirtualPostsService::WhereFinder::PRELOAD_ASSOCIATIONS_LOCALLY)
    end
  end
end
