# frozen_string_literal: true

class CreateCommentCounters < ActiveRecord::Migration[6.1]
  def change
    create_table :comment_counters do |t|
      t.references :subject, polymorphic: true, null: false, index: true
      t.bigint :comments_count, null: false, default: 0

      t.timestamps
    end
  end
end
