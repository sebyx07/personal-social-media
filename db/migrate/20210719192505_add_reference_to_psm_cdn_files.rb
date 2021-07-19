# frozen_string_literal: true

class AddReferenceToPsmCdnFiles < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      add_reference :psm_cdn_files, :cdn_storage_provider, null: false, foreign_key: true, index: true
      add_column :psm_cdn_files, :key_ciphertext, :string, null: false
      add_column :psm_cdn_files, :iv_ciphertext, :string, null: false
      remove_column :psm_cdn_files, :url
      add_column :psm_cdn_files, :cache_url, :text
    end
  end
end
