# frozen_string_literal: true

class CreateReactionCounters < ActiveRecord::Migration[6.1]
  def change
    create_table :reaction_counters do |t|
      t.references :subject, polymorphic: true, null: false, index: true
      t.string :character, null: false, index: true
      t.bigint :reactions_count, null: false, default: 1

      t.timestamps
    end
  end
end
