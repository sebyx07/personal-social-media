# frozen_string_literal: true

class ChangeReactionsCountFromReactionCounters < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      change_column :reaction_counters, :reactions_count, :bigint, null: false, default: 0
    end
  end
end
