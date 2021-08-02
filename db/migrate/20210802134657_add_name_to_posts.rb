# frozen_string_literal: true

class AddNameToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :name, :string

    Post.find_each do |post|
      post.generate_name
      post.save!
    end

    safety_assured do
      change_column :posts, :name, :string, null: false
    end
  end
end
