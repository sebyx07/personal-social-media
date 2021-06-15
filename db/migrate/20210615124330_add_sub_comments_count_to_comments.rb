# frozen_string_literal: true

class AddSubCommentsCountToComments < ActiveRecord::Migration[6.1]
  def change
    add_column :comments, :sub_comments_count, :bigint, null: false, default: 0
  end
end
