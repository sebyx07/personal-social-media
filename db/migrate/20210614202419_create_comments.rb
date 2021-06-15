# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.references :comment_counter, null: false, foreign_key: true, index: true
      t.references :parent_comment, foreign_key: { to_table: :comments }, index: true
      t.references :peer, foreign_key: true, null: false, index: true
      t.string :comment_type, null: false, default: :standard
      t.jsonb :content, null: false

      t.timestamps
    end
  end
end
