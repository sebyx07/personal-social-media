# frozen_string_literal: true

# == Schema Information
#
# Table name: psm_permanent_files
#
#  id                            :bigint           not null, primary key
#  archive_password_ciphertext   :text             not null
#  external_file_name            :string           not null
#  size_bytes                    :bigint           default(0), not null
#  status                        :string           default("pending"), not null
#  upload_percentage             :integer          default(0), not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  permanent_storage_provider_id :bigint           not null
#  psm_file_variant_id           :bigint           not null
#
# Indexes
#
#  index_psm_permanent_files_on_permanent_storage_provider_id  (permanent_storage_provider_id)
#
# Foreign Keys
#
#  fk_rails_...  (permanent_storage_provider_id => permanent_storage_providers.id)
#  fk_rails_...  (psm_file_variant_id => psm_file_variants.id)
#
class PsmPermanentFile < ApplicationRecord
  attr_accessor :virtual_file

  belongs_to :psm_file_variant
  belongs_to :external_account, optional: true
  belongs_to :permanent_storage_provider

  str_enum :status, %i(pending ready unavailable)

  encrypts :archive_password
  validates :archive_password, presence: true
  validates :size_bytes, presence: true
  validates :size_bytes, numericality: { greater_than: 0 }, on: :update, if: -> { ready? }
end
