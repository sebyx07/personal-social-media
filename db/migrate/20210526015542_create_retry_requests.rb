# frozen_string_literal: true

class CreateRetryRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :retry_requests do |t|
      t.text :payload, null: false, default: "{}"
      t.text :peer_ids, null: false, default: "[]"
      t.string :url, null: false
      t.string :request_method, null: false
      t.integer :retries, null: false, default: 0
      t.integer :max_retries, null: false, default: 0
      t.string :request_type, null: false
      t.string :status, null: false, default: :pending

      t.timestamps
    end
  end
end
