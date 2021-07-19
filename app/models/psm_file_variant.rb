# frozen_string_literal: true

# == Schema Information
#
# Table name: psm_file_variants
#
#  id                       :bigint           not null, primary key
#  cdn_storage_status       :string           default("pending"), not null
#  permanent_storage_status :string           default("pending"), not null
#  variant_metadata         :text             default("{}"), not null
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
  attr_accessor :original_physical_file
  attr_reader :variant_file, :size_bytes

  belongs_to :psm_file
  has_many :psm_permanent_files, dependent: :destroy
  has_many :psm_cdn_files, dependent: :destroy

  def create_variant_file!
    @variant_file = PsmFileVariantsService::BuildCustomVariant.new(self).call
    @size_bytes = variant_file.size
  end

  def clean_variant_file!
    return if variant_name.to_s == "original"
  end

  def new_variant_file_name
    @new_variant_file_name ||= SecureRandom.urlsafe_base64(32) + ".#{File.extname(original_physical_file)}"
  end

  def key
    @key ||= SecureRandom.bytes(32)
  end

  def iv
    @iv ||= SecureRandom.bytes(16)
  end
end
