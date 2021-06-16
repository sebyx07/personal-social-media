# frozen_string_literal: true

class AddColumnIsLatestToComments < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      add_column :comments, :is_latest, :boolean, null: false
    end
  end
end
