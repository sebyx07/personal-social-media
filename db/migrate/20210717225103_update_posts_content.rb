# frozen_string_literal: true

class UpdatePostsContent < ActiveRecord::Migration[6.1]
  def change
    RemotePost.destroy_all
    Post.destroy_all

    safety_assured do
      remove_column :posts, :content
      add_column :posts, :content, :jsonb, null: false
    end
  end
end
