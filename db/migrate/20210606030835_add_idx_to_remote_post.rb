class AddIdxToRemotePost < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      add_index :remote_posts, :created_at
    end
  end
end
