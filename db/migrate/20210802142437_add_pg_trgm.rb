# frozen_string_literal: true

class AddPgTrgm < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    enable_extension :pg_trgm

    add_index :posts, :name, opclass: :gin_trgm_ops, using: :gin, algorithm: :concurrently
  end
end
