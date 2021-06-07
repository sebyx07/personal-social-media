# frozen_string_literal: true

class AddShowInFeedToPosts < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      add_column :posts, :show_in_feed, :boolean, null: false, default: false

      Post.update_all(show_in_feed: true)
    end
  end
end
