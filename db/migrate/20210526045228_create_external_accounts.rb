# frozen_string_literal: true

class CreateExternalAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :external_accounts do |t|
      t.string :name, null: false
      t.string :service, null: false
      t.text :secret_key_ciphertext
      t.text :public_key_ciphertext
      t.text :username_ciphertext
      t.text :password_ciphertext
      t.text :email_ciphertext
      t.text :secret_ciphertext

      t.timestamps
    end
  end
end
