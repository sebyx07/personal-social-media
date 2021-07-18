# frozen_string_literal: true

# == Schema Information
#
# Table name: psm_files
#
#  id                       :bigint           not null, primary key
#  cdn_storage_status       :string           default("pending"), not null
#  content_type             :string           not null
#  iv_ciphertext            :text             not null
#  key_ciphertext           :text             not null
#  metadata                 :jsonb            not null
#  name                     :string           not null
#  permanent_storage_status :string           default("pending"), not null
#  subject_type             :string           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  subject_id               :bigint           not null
#
# Indexes
#
#  index_psm_files_on_metadata  (metadata) USING gin
#  index_psm_files_on_subject   (subject_type,subject_id)
#
class PsmFile < ApplicationRecord
  belongs_to :subject, polymorphic: true
  has_one :original, -> { where(variant_name: :original) }, class_name: "PsmFileVariant"
  has_many :psm_file_variants
  has_many :psm_permanent_files, through: :psm_file_variants
  encrypts :key, :iv

  after_initialize do |psm_file|
    next if psm_file.persisted?
    psm_file.key ||= SecureRandom.bytes(32)
    psm_file.iv ||= SecureRandom.bytes(16)
  end
end
