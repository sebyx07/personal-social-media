# frozen_string_literal: true

# == Schema Information
#
# Table name: psm_file_variants
#
#  id                       :bigint           not null, primary key
#  cdn_storage_status       :string           default("pending"), not null
#  external_file_name       :string           not null
#  iv_ciphertext            :string           not null
#  key_ciphertext           :string           not null
#  permanent_storage_status :string           default("pending"), not null
#  size_bytes               :bigint           default(0), not null
#  variant_metadata         :jsonb            not null
#  variant_name             :string           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  psm_file_id              :bigint           not null
#
# Indexes
#
#  index_psm_file_variants_on_psm_file_id_and_variant_name  (psm_file_id,variant_name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (psm_file_id => psm_files.id)
#
class PsmFileVariant < ApplicationRecord
  include Memo
  encrypts :key, type: :binary
  encrypts :iv, type: :binary
  attr_accessor :original_physical_file
  attr_reader :variant_file

  belongs_to :psm_file
  has_many :psm_permanent_files, dependent: :destroy
  has_many :psm_cdn_files, dependent: :destroy

  after_initialize do |psm_file_variant|
    next if psm_file_variant.persisted?
    psm_file_variant.key ||= SecureRandom.bytes(32)
    psm_file_variant.iv ||= SecureRandom.bytes(16)
  end

  def create_variant_file!
    return if variant_file.present?
    result = PsmFileVariantsService::BuildCustomVariant.new(self).call
    @variant_file = result[:encrypted_file]
    self.variant_metadata = result[:metadata]
    self.external_file_name = new_variant_file_name
    self.size_bytes = variant_file.size
  end

  def clean_variant_file!
    return if variant_name.to_s == "original"
    return unless File.exist?(variant_file.path)
    File.delete(variant_file.path)
  end

  def new_variant_file_name
    @new_variant_file_name ||= SecureRandom.urlsafe_base64(32) + ".#{File.extname(original_physical_file)}"
  end
end
