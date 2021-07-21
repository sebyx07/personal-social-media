# frozen_string_literal: true

class CreatePsmAttachments < ActiveRecord::Migration[6.1]
  def change
    create_table :psm_attachments do |t|
      t.references :subject, polymorphic: true, null: false, index: true
      t.references :psm_file, null: false, foreign_key: true, index: true

      t.timestamps
    end

    safety_assured do
      remove_column :psm_files, :subject_type
      remove_column :psm_files, :subject_id
    end
  end
end
