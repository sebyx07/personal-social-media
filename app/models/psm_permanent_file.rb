# frozen_string_literal: true

# == Schema Information
#
# Table name: psm_permanent_files
#
#  id                          :bigint           not null, primary key
#  adapter                     :string           not null
#  archive_password_ciphertext :text             not null
#  external_file_name          :string           not null
#  size_bytes                  :bigint           default(0), not null
#  status                      :string           default("pending"), not null
#  upload_percentage           :integer          default(0), not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  external_account_id         :bigint
#  psm_file_variant_id         :bigint           not null
#
# Indexes
#
#  idx_psm_permanent_files_variant_to_external_account  (psm_file_variant_id,external_account_id) UNIQUE
#  index_psm_permanent_files_on_external_account_id     (external_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (external_account_id => external_accounts.id)
#  fk_rails_...  (psm_file_variant_id => psm_file_variants.id)
#
class PsmPermanentFile < ApplicationRecord
  attr_accessor :virtual_file
  attr_writer :adapter_instance

  belongs_to :psm_file_variant
  belongs_to :external_account, optional: true
  str_enum :status, %i(pending ready unavailable)

  encrypts :archive_password
  validates :archive_password, presence: true
  validates :size_bytes, presence: true
  validates :size_bytes, numericality: { greater_than: 0 }, on: :update, if: -> { ready? }
  validates :adapter, presence: true
  validate :validate_adapter

  attr_reader :adapter_instance

  private
    def validate_adapter
      adapter.constantize
    rescue NameError => e
      errors.add(:adapter, e.message)
    end
end
