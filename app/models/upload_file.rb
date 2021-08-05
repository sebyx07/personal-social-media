# frozen_string_literal: true

# == Schema Information
#
# Table name: upload_files
#
#  id             :bigint           not null, primary key
#  client_sha_256 :string(64)       not null
#  file_name      :string           not null
#  status         :string           default("pending"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  upload_id      :bigint           not null
#
# Indexes
#
#  index_upload_files_on_upload_id_and_client_sha_256  (upload_id,client_sha_256) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (upload_id => uploads.id)
#
class UploadFile < ApplicationRecord
  scope :dangling, -> { where("updated_at < ?", 1.day.ago) }
  belongs_to :upload, counter_cache: true
  str_enum :status, %i(pending ready)
  has_many :upload_file_chunks, dependent: :delete_all
  has_many :upload_file_logs, dependent: :nullify
  validates :client_sha_256, presence: true, uniqueness: { scope: :upload_id }, length: { is: 64 }

  def clean_parent_upload
    upload.destroy if UploadFile.where(upload_id: upload_id).count.zero?
  end
end
