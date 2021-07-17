# frozen_string_literal: true

class CreateUploads < ActiveRecord::Migration[6.1]
  def change
    create_table :uploads do |t|
      t.references :subject, polymorphic: true, null: false, index: true
      t.string :status, null: false, default: :pending
      t.string :resumable_upload_identifier

      t.timestamps
    end
  end
end
