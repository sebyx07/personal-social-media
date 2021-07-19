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
FactoryBot.define do
  factory :psm_file_variant do
    psm_file { nil }
  end
end
