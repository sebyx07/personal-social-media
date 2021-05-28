# frozen_string_literal: true

class AddBackupPasswordDigestToProfiles < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      remove_column :profiles, :backup_password_digest if column_exists?(:profiles, :backup_password_digest)
      add_column :profiles, :backup_password_ciphertext, :string
      Profile.all.each do |profile|
        profile.send(:generate_backup_password)
        profile.save!
      end

      change_column :profiles, :backup_password_ciphertext, :string, null: false
    end
  end
end
