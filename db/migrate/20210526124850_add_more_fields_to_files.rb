# frozen_string_literal: true

class AddMoreFieldsToFiles < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      add_column :psm_files, :permanent_storage_status, :string, default: :pending, null: false
      add_column :psm_files, :cdn_storage_status, :string, default: :pending, null: false
      add_column :psm_file_variants, :permanent_storage_status, :string, default: :pending, null: false
      add_column :psm_file_variants, :cdn_storage_status, :string, default: :pending, null: false

      add_column :psm_permanent_files, :archive_password_ciphertext, :text, null: false
      add_column :psm_permanent_files, :upload_percentage, :integer, null: false, default: 0
      add_column :psm_cdn_files, :upload_percentage, :integer, null: false, default: 0
      change_column :psm_permanent_files, :size_bytes, :bigint, null: false, default: 0
      change_column :psm_cdn_files, :size_bytes, :bigint, null: false, default: 0
    end
  end
end
