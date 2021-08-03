# frozen_string_literal: true

ActiveAdmin.register PsmFile, namespace: :management do
  decorate_with ManagementPsmFileDecorator
  actions :index, :show, :destroy

  filter :name
  filter(:posts, as: :searchable_select, ajax: true)

  index do
    selectable_column
    column :id
    column :preview do |r|
      react_component "mountable-in-management/mountable-psm-file", data: r.presented
    end
    column :name
    column :content_type
    column :created_at

    actions do
      link_to "Download", root_path
    end
  end

  controller do
    def scoped_collection
      super.includes(psm_file_variants: [psm_cdn_files: :cdn_storage_provider])
    end
  end
end
