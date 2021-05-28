# frozen_string_literal: true

class CreateRemotePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :remote_posts do |t|
      t.bigint :remote_post_id, null: false
      t.references :peer, null: false, foreign_key: true
      t.index [:remote_post_id, :peer_id], unique: true

      t.timestamps
    end
  end
end
