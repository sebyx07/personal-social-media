# frozen_string_literal: true

class CreatePsmFiles < ActiveRecord::Migration[6.1]
  def change
    create_table :psm_files do |t|
      t.string :name, null: false
      t.string :content_type, null: false
      t.jsonb :metadata, null: false
      t.references :subject, polymorphic: true, null: false, index: true

      t.timestamps
    end

    add_index :psm_files, :metadata, using: :gin
  end
end
