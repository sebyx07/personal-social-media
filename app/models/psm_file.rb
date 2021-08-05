# frozen_string_literal: true

# == Schema Information
#
# Table name: psm_files
#
#  id                       :bigint           not null, primary key
#  cdn_storage_status       :string           default("pending"), not null
#  content_type             :string           not null
#  metadata                 :jsonb            not null
#  name                     :string           not null
#  permanent_storage_status :string           default("pending"), not null
#  sha_256                  :string(64)       not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
# Indexes
#
#  index_psm_files_on_metadata  (metadata) USING gin
#  index_psm_files_on_sha_256   (sha_256) UNIQUE
#
class PsmFile < ApplicationRecord
  include Memo
  has_many :psm_attachments, dependent: :destroy
  has_many :posts, through: :psm_attachments, source: :subject, source_type: "Post"
  has_one :original, -> { where(variant_name: :original) }, class_name: "PsmFileVariant"
  has_many :psm_file_variants, dependent: :destroy
  has_many :psm_permanent_files, through: :psm_file_variants
  has_many :psm_cdn_files, through: :psm_file_variants
  str_enum :cdn_storage_status, %i(pending ready), prefix: :cdn
  str_enum :permanent_storage_status, %i(pending ready), prefix: :permanent
  attr_accessor :client_sha_256
  validates :sha_256, presence: true, uniqueness: true, length: { is: 64 }
  validate :check_sha_256_from_client

  def type
    memo(:@type) do
      if content_type.match?(/^image\//)
        :image
      else
        :unknown
      end
    end
  end

  def check_sha_256_from_client
    return if client_sha_256.blank?
    errors.add(:sha_256, "files don't match") unless client_sha_256 == sha_256
  end
end
