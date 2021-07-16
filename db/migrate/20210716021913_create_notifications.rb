# frozen_string_literal: true

class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :peer, null: false, foreign_key: true, index: true
      t.string :type, null: false
      t.jsonb :content, null: false, default: "{}"
      t.boolean :seen, null: false, default: false
      t.references :subject, polymorphic: true, index: true

      t.timestamps
    end
  end
end
