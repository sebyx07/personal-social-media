# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.text :content
      t.string :status, null: false, default: :pending

      t.timestamps
    end
  end
end
