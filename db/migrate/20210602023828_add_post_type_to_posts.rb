# frozen_string_literal: true

class AddPostTypeToPosts < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      add_column :posts, :post_type, :string, null: false, default: :standard
      add_column :remote_posts, :post_type, :string, null: false, default: :standard
    end
  end
end
