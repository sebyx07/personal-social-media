# frozen_string_literal: true

class CreatePeers < ActiveRecord::Migration[6.1]
  def change
    create_table :peers do |t|
      t.binary :public_key, null: false
      t.binary :verify_key, null: false
      t.string :domain_name, null: false
      t.string :name, null: false
      t.string :status, null: false
      t.string :avatar_url, null: false, default: :stranger

      t.timestamps
    end
  end
end
