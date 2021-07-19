# frozen_string_literal: true

class CreateCdnStorageProviders < ActiveRecord::Migration[6.1]
  def change
    create_table :cdn_storage_providers do |t|
      t.string :adapter, null: false
      t.boolean :enabled, null: false, default: false
      t.string :free_space_bytes, null: false, default: "0"
      t.string :used_space_bytes, null: false, default: "0"
      t.references :external_account, null: true, foreign_key: true

      t.timestamps
    end

    safety_assured do
      remove_column :psm_cdn_files, :external_account_id
    end
  end
end
