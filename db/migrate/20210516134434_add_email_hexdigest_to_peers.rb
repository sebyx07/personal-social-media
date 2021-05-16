# frozen_string_literal: true

class AddEmailHexdigestToPeers < ActiveRecord::Migration[6.1]
  def up
    add_column :peers, :email_hexdigest, :string
    remove_column :peers, :avatar_url
    add_column :peers, :nickname, :string
  end

  def down
    remove_column :peers, :nickname
    remove_column :peers, :email_hexdigest
    add_column :peers, :avatar_url, :string
  end
end
