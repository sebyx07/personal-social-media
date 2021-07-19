# frozen_string_literal: true

class AddReferenceToPsmCdnFiles < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      add_reference :psm_cdn_files, :cdn_storage_provider, null: false, foreign_key: true, index: true
      add_column :psm_file_variants, :key_ciphertext, :string, null: false
      add_column :psm_file_variants, :iv_ciphertext, :string, null: false
      remove_column :psm_cdn_files, :url
      remove_column :psm_cdn_files, :size_bytes
      remove_column :psm_cdn_files, :external_file_name
      add_column :psm_file_variants, :size_bytes, :bigint, null: false, default: 0
      add_column :psm_file_variants, :external_file_name, :string, null: false
      add_column :psm_cdn_files, :cache_url, :text
    end
  end
end
