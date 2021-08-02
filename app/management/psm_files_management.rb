# frozen_string_literal: true

ActiveAdmin.register PsmFile, namespace: :management do
  decorate_with ManagementPsmFileDecorator

  filter :name
  filter(:posts, as: :searchable_select, ajax: true)
end
