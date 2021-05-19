# frozen_string_literal: true

class AddIndexesToPeers < ActiveRecord::Migration[6.1]
  def change
    add_index :peers, :public_key
    add_index :peers, :verify_key
    add_index :peers, :status_mask
  end
end
