# frozen_string_literal: true

class AddEncryptionToPsmFiles < ActiveRecord::Migration[6.1]
  def change
    add_column :psm_files, :key_ciphertext, :text, null: false
    add_column :psm_files, :iv_ciphertext, :text, null: false
  end
end
