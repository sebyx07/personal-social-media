# frozen_string_literal: true

ActiveAdmin.register CdnStorageProvider, namespace: :management do
  menu parent: "Storage", label: "CDN (Content Delivery Network)"
  permit_params :adapter, :enabled
  decorate_with ManagementCdnStorageProviderDecorator

  index do
    selectable_column
    column :id
    column :adapter do |storage|
      storage.name
    end

    column :created_at
    column :updated_at
    column :free_space_bytes do |storage|
      storage.free_space_bytes_h
    end

    column :free_space_bytes do |storage|
      storage.free_space_bytes_h
    end

    actions
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    columns do
      column do
        f.input :adapter, as: :select, collection: translated_cdn_storage_providers, include_blank: false, input_html: {
          disabled: persisted?
        }
        f.input :enabled, as: :boolean
      end
      column
    end

    f.actions
  end

  controller do
    def translated_cdn_storage_providers
      @translated_cdn_storage_providers ||= CdnStorageProvider::PERMITTED_ADAPTERS.map do |adapter|
        full_name = [I18n.t("storage_adapters.#{adapter}.name"), I18n.t("storage_adapters.#{adapter}.description")].join(" ")

        [full_name, adapter]
      end
    end

    delegate :persisted?, to: :@cdn_storage_provider
    helper_method :translated_cdn_storage_providers, :persisted?
  end
end
