# frozen_string_literal: true

class AddUploadFilesCountToUploads < ActiveRecord::Migration[6.1]
  def change
    add_column :uploads, :upload_files_count, :integer, null: false, default: 0
  end
end
