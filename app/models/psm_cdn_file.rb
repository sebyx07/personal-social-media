# frozen_string_literal: true

# == Schema Information
#
# Table name: psm_cdn_files
#
#  id                      :bigint           not null, primary key
#  cache_url               :text
#  status                  :string           default("pending"), not null
#  upload_percentage       :integer          default(0), not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  cdn_storage_provider_id :bigint           not null
#  psm_file_variant_id     :bigint           not null
#
# Indexes
#
#  index_psm_cdn_files_on_cdn_storage_provider_id  (cdn_storage_provider_id)
#
# Foreign Keys
#
#  fk_rails_...  (cdn_storage_provider_id => cdn_storage_providers.id)
#  fk_rails_...  (psm_file_variant_id => psm_file_variants.id)
#
class PsmCdnFile < ApplicationRecord
  attr_accessor :virtual_file

  delegate :size_bytes, to: :psm_file_variant
  belongs_to :psm_file_variant
  belongs_to :cdn_storage_provider
  has_one :psm_file, through: :psm_file_variant
  before_save :update_cdn_storage_provider

  private
    def update_cdn_storage_provider
      cdn_storage_provider.used_space_bytes += size_bytes
      cdn_storage_provider.save!
    end
end
