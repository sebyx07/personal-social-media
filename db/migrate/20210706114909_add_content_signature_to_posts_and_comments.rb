# frozen_string_literal: true

class AddContentSignatureToPostsAndComments < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      Comment.destroy_all

      add_column :posts, :signature, :binary

      Post.find_each do |post|
        post.send(:generate_signature)
        post.save!
      end

      change_column :posts, :signature, :binary, null: false
    end
  end
end
