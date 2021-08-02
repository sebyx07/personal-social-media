# frozen_string_literal: true

# == Schema Information
#
# Table name: upload_file_logs
#
#  id                            :bigint           not null, primary key
#  log_status                    :string           not null
#  message                       :text             not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  cdn_storage_provider_id       :bigint
#  permanent_storage_provider_id :bigint
#  psm_file_variant_id           :bigint
#  psm_permanent_file_id         :bigint
#  upload_file_id                :bigint
#
# Indexes
#
#  index_upload_file_logs_on_cdn_storage_provider_id        (cdn_storage_provider_id)
#  index_upload_file_logs_on_permanent_storage_provider_id  (permanent_storage_provider_id)
#  index_upload_file_logs_on_psm_file_variant_id            (psm_file_variant_id)
#  index_upload_file_logs_on_psm_permanent_file_id          (psm_permanent_file_id)
#  index_upload_file_logs_on_upload_file_id                 (upload_file_id)
#
# Foreign Keys
#
#  fk_rails_...  (cdn_storage_provider_id => cdn_storage_providers.id)
#  fk_rails_...  (permanent_storage_provider_id => permanent_storage_providers.id)
#  fk_rails_...  (psm_file_variant_id => psm_file_variants.id)
#  fk_rails_...  (psm_permanent_file_id => psm_permanent_files.id)
#  fk_rails_...  (upload_file_id => upload_files.id)
#
class UploadFileLog < ApplicationRecord
  belongs_to :upload_file, optional: true
  belongs_to :permanent_storage_provider, optional: true
  belongs_to :cdn_storage_provider, optional: true
  belongs_to :psm_file_variant, optional: true
  belongs_to :psm_permanent_file, optional: true

  str_enum :log_status, %i(ok error)
  validates :log_status, presence: true
  validates :message, presence: true

  class << self
    def create_log!(filename, options)
      message = "File:#{filename} => #{options[:message]}"
      create!(options.merge(message: message))
    end
  end
end
