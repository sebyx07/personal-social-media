# frozen_string_literal: true

class RenameColumnCacheCommentsRemoteId < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      rename_column :cache_comments, :remote_id, :remote_comment_id
      add_column :cache_comments, :remote_parent_comment_id, :bigint
    end
  end
end
