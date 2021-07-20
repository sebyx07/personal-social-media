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
FactoryBot.define do
  factory :psm_file do
    cdn_storage_status { :ready }
    permanent_storage_status { :ready }

    trait :test_image do
      metadata { {} }
      content_type { "image" }
      sha_256 { SecureRandom.hex }
      name { SecureRandom.hex }
    end
  end
end
