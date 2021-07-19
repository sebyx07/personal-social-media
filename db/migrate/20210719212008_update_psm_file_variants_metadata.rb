# frozen_string_literal: true

class UpdatePsmFileVariantsMetadata < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      remove_column :psm_file_variants, :variant_metadata
      add_column :psm_file_variants, :variant_metadata, :jsonb, null: false, default: "{}"
    end
  end
end
