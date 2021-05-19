# frozen_string_literal: true

class AddServerLastSeenAtToPeers < ActiveRecord::Migration[6.1]
  def change
    add_column :peers, :server_last_seen_at, :datetime
    add_column :peers, :last_seen_at, :datetime
  end
end
