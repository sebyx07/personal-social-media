# frozen_string_literal: true

class FixIndexes7June2021 < ActiveRecord::Migration[6.1]
  def change
    remove_index :psm_cdn_files, :psm_file_variant_id if index_exists? :psm_cdn_files, :psm_file_variant_id
    remove_index :psm_file_permanents, :psm_file_variant_id if index_exists? :psm_file_permanents, :psm_file_variant_id
    remove_index :psm_file_variants, :psm_file_id if index_exists? :psm_file_variants, :psm_file_id
    remove_index :psm_permanent_files, :psm_file_variant_id if index_exists? :psm_permanent_files, :psm_file_variant_id
  end
end
