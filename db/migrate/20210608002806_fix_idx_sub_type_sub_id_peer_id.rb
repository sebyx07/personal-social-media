# frozen_string_literal: true

class FixIdxSubTypeSubIdPeerId < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      remove_index :cache_reactions, name: "idx_sub_type_sub_id_peer_id"
      add_index :cache_reactions, %i(character subject_type subject_id peer_id), name: "idx_sub_type_sub_id_peer_id"
    end
  end
end
