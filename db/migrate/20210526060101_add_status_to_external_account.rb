# frozen_string_literal: true

class AddStatusToExternalAccount < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      add_column :external_accounts, :status, :string, null: false, default: :initializing
      add_column :external_accounts, :usage, :string, null: false
    end
  end
end
