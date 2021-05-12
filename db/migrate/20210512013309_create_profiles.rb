# frozen_string_literal: true

class CreateProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :profiles do |t|
      t.text :pk_ciphertext, null: false
      t.string :name, null: false
      t.string :nickname, null: false
      t.string :email, null: false
      t.string :password_plain
      t.string :password_digest, null: false

      t.timestamps
    end
  end
end
