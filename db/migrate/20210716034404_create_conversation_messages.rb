# frozen_string_literal: true

class CreateConversationMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :conversation_messages do |t|
      t.references :conversation, null: false, foreign_key: true
      t.references :peer, null: false, foreign_key: true
      t.jsonb :content, null: false
      t.string :conversation_message_type, null: false
      t.boolean :seen, null: false
      t.bigint :remote_conversation_message_id

      t.timestamps
    end
  end
end
