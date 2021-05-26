# frozen_string_literal: true

class AddExternalFileNameToPsmPermanentFiles < ActiveRecord::Migration[6.1]
  def change
    add_column :psm_permanent_files, :external_file_name, :string, null: false
    add_column :psm_cdn_files, :external_file_name, :string, null: false
  end
end
