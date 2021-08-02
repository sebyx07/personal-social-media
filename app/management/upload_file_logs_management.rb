# frozen_string_literal: true

ActiveAdmin.register UploadFileLog, namespace: :management do
  decorate_with ManagementUploadFileLogDecorator
  menu parent: "Storage", label: "Logs"
  actions :index, :show, :destroy

  filter :message
  filter(:upload_file, as: :searchable_select, ajax: true)

  index do
    selectable_column
    column :id
    column :message, sortable: false do |r|
      r.colored_message
    end
    column :created_at

    actions
  end
end
