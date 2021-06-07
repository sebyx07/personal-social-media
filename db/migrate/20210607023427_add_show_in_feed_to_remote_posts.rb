# frozen_string_literal: true

class AddShowInFeedToRemotePosts < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      add_column :remote_posts, :show_in_feed, :boolean, null: false, default: false

      RemotePost.update_all(show_in_feed: true)

      remove_column :posts, :show_in_feed if column_exists? :posts, :show_in_feed
      remove_index :remote_posts, :created_at
    end
  end
end
