# frozen_string_literal: true

class AddIsMeToPeers < ActiveRecord::Migration[6.1]
  def change
    add_column :peers, :is_me, :boolean

    Profile.first&.send(:generate_self_peer!)
  end
end
