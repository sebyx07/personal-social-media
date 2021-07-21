# frozen_string_literal: true

ActiveAdmin.register ExternalAccount, namespace: :management do
  searchable_select_options(scope: ->(params) do
    scoped_collection.where(usage: params[:usage])
  end,
  text_attribute: :name)
end
