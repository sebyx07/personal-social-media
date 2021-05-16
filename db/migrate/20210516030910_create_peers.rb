# frozen_string_literal: true

class CreatePeers < ActiveRecord::Migration[6.1]
  def change
    create_table :peers do |t|
      t.binary :public_key, null: false
      t.binary :verify_key
      t.string :domain_name, null: false
      t.string :name
      t.bigint :status_mask, null: false, default: 0
      t.string :avatar_url

      t.timestamps
    end
  end
end
