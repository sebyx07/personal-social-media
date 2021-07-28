# frozen_string_literal: true

class UpdatePsmFiles < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      add_index :psm_permanent_files, :external_file_name, unique: true
      add_index :psm_file_variants, :external_file_name, unique: true
      add_column :psm_cdn_files, :parts, :integer, null: false, default: 0
      add_column :psm_cdn_files, :parts_metadata, :jsonb, null: false, default: "{}"
    end
  end
end
