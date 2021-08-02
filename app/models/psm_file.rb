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
#
class PsmFile < ApplicationRecord
  include Memo
  has_many :psm_attachments
  has_one :original, -> { where(variant_name: :original) }, class_name: "PsmFileVariant"
  has_many :psm_file_variants, dependent: :destroy
  has_many :psm_permanent_files, through: :psm_file_variants
  has_many :psm_cdn_files, through: :psm_file_variants
  str_enum :cdn_storage_status, %i(pending ready), prefix: :cdn
  str_enum :permanent_storage_status, %i(pending ready), prefix: :permanent

  def type
    memo(:@type) do
      if content_type.match?(/^image\//)
        :image
      else
        :unknown
      end
    end
  end
end
