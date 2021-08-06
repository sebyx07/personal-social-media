# frozen_string_literal: true

ActiveAdmin.register UploadFile, namespace: :management do
  searchable_select_options(scope: -> { scoped_collection }, text_attribute: :file_name, filter: ->(term, scope) do
    scope.ransack(file_name_cont_all: term.split(" ")).result
  end)
  menu false

  controller do
    def scoped_collection
      UploadFile.all
    end

    def action_methods
      super - %w(index edit update destroy create show new batch_action)
    end
  end
end
