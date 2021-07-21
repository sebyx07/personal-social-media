# frozen_string_literal: true

class RemoveSignatureFromPosts < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      remove_column :posts, :signature
    end
  end
end
