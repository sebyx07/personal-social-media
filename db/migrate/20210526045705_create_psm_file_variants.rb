# frozen_string_literal: true

class CreatePsmFileVariants < ActiveRecord::Migration[6.1]
  def change
    create_table :psm_file_variants do |t|
      t.references :psm_file, null: false, foreign_key: true, index: true
      t.string :variant_name, null: false
      t.text :variant_metadata, null: false, default: "{}"

      t.timestamps
    end

    add_index :psm_file_variants, %i(psm_file_id variant_name), unique: true
  end
end
