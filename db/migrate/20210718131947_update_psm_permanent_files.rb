# frozen_string_literal: true

class UpdatePsmPermanentFiles < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      change_column :psm_permanent_files, :external_account_id, :bigint, null: true
      add_column :psm_permanent_files, :adapter, :string, null: false
    end
  end
end
