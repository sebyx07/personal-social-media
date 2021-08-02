# frozen_string_literal: true

class CreateUploadFileLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :upload_file_logs do |t|
      t.references :upload_file, null: true, foreign_key: true
      t.text :message, null: false
      t.string :log_status, null: false
      t.references :permanent_storage_provider, null: true, foreign_key: true
      t.references :cdn_storage_provider, null: true, foreign_key: true
      t.references :psm_file_variant, null: true, foreign_key: true
      t.references :psm_permanent_file, null: true, foreign_key: true

      t.timestamps
    end
  end
end
