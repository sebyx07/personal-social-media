# frozen_string_literal: true

class CreateUploadFileChunks < ActiveRecord::Migration[6.1]
  def change
    create_table :upload_file_chunks do |t|
      t.references :upload_file, null: false, foreign_key: true, index: false
      t.bigint :resumable_chunk_number, null: false
      t.binary :payload, null: false

      t.timestamps
    end

    add_index :upload_file_chunks, %i(upload_file_id resumable_chunk_number), unique: true,
              name: :index_upload_file_chunks_on_upload_id_resumable

    remove_index :upload_files, :upload_id
    remove_index :upload_files, :file_name

    safety_assured do
      add_index :upload_files, %i(upload_id file_name), unique: true
    end
  end
end
