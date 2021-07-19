# frozen_string_literal: true

class CreatePermanentStorageProviders < ActiveRecord::Migration[6.1]
  def change
    create_table :permanent_storage_providers do |t|
      t.references :external_account, null: true, foreign_key: true, index: true
      t.string :adapter, null: false
      t.string :used_space_bytes, null: false, default: "0"
      t.string :free_space_bytes, null: false, default: "0"
      t.boolean :enabled, default: false, null: false

      t.timestamps
    end

    safety_assured do
      remove_column :psm_permanent_files, :adapter
      remove_column :psm_permanent_files, :external_account_id

      add_reference :psm_permanent_files, :permanent_storage_provider, null: false, foreign_key: true, index: true
    end
  end
end
