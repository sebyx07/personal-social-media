# frozen_string_literal: true

class AddSigningKeyToProfiles < ActiveRecord::Migration[6.1]
  def change
    add_column :profiles, :sk_ciphertext, :text, null: false
  end
end
