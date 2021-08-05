# frozen_string_literal: true

class FixUploadFileIndexes < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      remove_index :upload_files, [:upload_id, :file_name]

      add_index :upload_files, [:upload_id, :client_sha_256], unique: true
    end
  end
end
