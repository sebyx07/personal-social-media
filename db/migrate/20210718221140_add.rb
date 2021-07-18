# frozen_string_literal: true

class Add < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      add_column :psm_files, :sha_256, :string, limit: 64, null: false, index: {
        unique: true
      }
    end
  end
end
