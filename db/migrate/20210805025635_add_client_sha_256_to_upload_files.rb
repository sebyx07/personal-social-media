# frozen_string_literal: true

class AddClientSha256ToUploadFiles < ActiveRecord::Migration[6.1]
  def change
    add_column :upload_files, :client_sha_256, :string, limit: 64, index: { unique: true }

    safety_assured do
      add_index :psm_files, :sha_256, unique: true
    end
  end
end
