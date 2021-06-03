# frozen_string_literal: true

class AddRemoteReactionIdToCacheReactions < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      add_column :cache_reactions, :remote_reaction_id, :bigint, null: false
    end
  end
end
