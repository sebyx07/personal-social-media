# frozen_string_literal: true

class RemoveKeyIvFromPsmFiles < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      remove_column :psm_files, :key_ciphertext
      remove_column :psm_files, :iv_ciphertext
    end
  end
end
