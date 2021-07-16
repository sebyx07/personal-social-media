# frozen_string_literal: true

class CreateConversations < ActiveRecord::Migration[6.1]
  def change
    create_table :conversations do |t|
      t.references :peer, null: false, foreign_key: true, index: true
      t.boolean :is_focused, null: false, default: false
      t.bigint :unread_messages_count, null: false, default: 0

      t.timestamps
    end
  end
end
