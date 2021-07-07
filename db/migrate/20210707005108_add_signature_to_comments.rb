# frozen_string_literal: true

class AddSignatureToComments < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      add_column :comments, :signature, :binary, null: false
    end
  end
end
