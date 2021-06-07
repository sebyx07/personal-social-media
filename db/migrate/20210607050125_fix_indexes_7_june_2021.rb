# frozen_string_literal: true

class FixIndexes7June2021 < ActiveRecord::Migration[6.1]
  def change
    remove_index :psm_cdn_files, name: "index_psm_cdn_files_on_psm_file_variant_id", column: :psm_file_variant_id
    remove_index :psm_file_permanents, name: "index_psm_file_permanents_on_psm_file_variant_id", column: :psm_file_variant_id
    remove_index :psm_file_variants, name: "index_psm_file_variants_on_psm_file_id", column: :psm_file_id
    remove_index :psm_permanent_files, name: "index_psm_permanent_files_on_psm_file_variant_id", column: :psm_file_variant_id
  end
end
