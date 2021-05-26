# frozen_string_literal: true

class CreatePsmPermanentFiles < ActiveRecord::Migration[6.1]
  def change
    create_table :psm_permanent_files do |t|
      t.integer :size_bytes, null: false, default: 0
      t.string :status, null: false, default: :pending
      t.references :psm_file_variant, null: false, foreign_key: true, index: true
      t.references :external_account, null: false, foreign_key: true, index: true

      t.timestamps
    end

    add_index :psm_permanent_files, %i(psm_file_variant_id external_account_id), unique: true, name: "idx_psm_permanent_files_variant_to_external_account"
  end
end
