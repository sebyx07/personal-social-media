# frozen_string_literal: true

class CreateCacheReactions < ActiveRecord::Migration[6.1]
  def change
    create_table :cache_reactions do |t|
      t.string :character, null: false
      t.references :subject, polymorphic: true, null: false, index: true

      t.timestamps
    end
  end
end
