# frozen_string_literal: true

class AddViewsToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :views, :bigint, null: false, default: 0
  end
end
