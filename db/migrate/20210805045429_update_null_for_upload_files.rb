# frozen_string_literal: true

class UpdateNullForUploadFiles < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      change_column_null :upload_files, :file_name, false
      change_column_null :upload_files, :client_sha_256, false
    end
  end
end
