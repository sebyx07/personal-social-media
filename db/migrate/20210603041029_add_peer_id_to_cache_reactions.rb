# frozen_string_literal: true

class AddPeerIdToCacheReactions < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      add_reference :cache_reactions, :peer, null: false, foreign_key: true, index: false
      remove_index :cache_reactions, %i(subject_type subject_id)
      add_index :cache_reactions, %i(subject_type subject_id peer_id), unique: true, name: "idx_sub_type_sub_id_peer_id"
    end
  end
end
