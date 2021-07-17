# frozen_string_literal: true

class CreateUploadFiles < ActiveRecord::Migration[6.1]
  def change
    create_table :upload_files do |t|
      t.references :upload, null: false, foreign_key: true, index: true
      t.string :file_name, index: true
      t.string :status, null: false, default: :pending

      t.timestamps
    end
  end
end
