# frozen_string_literal: true

class CreateCacheComments < ActiveRecord::Migration[6.1]
  def change
    create_table :cache_comments do |t|
      t.references :subject, polymorphic: true, null: false, index: true
      t.references :peer, foreign_key: true, null: false, index: true
      t.bigint :remote_id, null: false
      t.string :comment_type, null: false
      t.jsonb :content, null: false

      t.timestamps
    end
  end
end
