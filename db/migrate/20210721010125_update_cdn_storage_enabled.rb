# frozen_string_literal: true

class UpdateCdnStorageEnabled < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      change_column :cdn_storage_providers, :enabled, :boolean, null: false, default: true
      change_column :permanent_storage_providers, :enabled, :boolean, null: false, default: true
    end
  end
end
