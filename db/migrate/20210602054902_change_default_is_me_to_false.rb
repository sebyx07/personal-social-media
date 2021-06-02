# frozen_string_literal: true

class ChangeDefaultIsMeToFalse < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      change_column :peers, :is_me, :boolean, default: false
      Peer.where.not(id: Peer.find_by(is_me: true).id).update_all(is_me: false)
      change_column :peers, :is_me, :boolean, default: false, null: false
    end
  end
end
