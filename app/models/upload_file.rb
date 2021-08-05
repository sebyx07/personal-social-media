# frozen_string_literal: true

# == Schema Information
#
# Table name: upload_files
#
#  id             :bigint           not null, primary key
#  client_sha_256 :string(64)
#  file_name      :string
#  status         :string           default("pending"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  upload_id      :bigint           not null
#
# Indexes
#
#  index_upload_files_on_upload_id_and_file_name  (upload_id,file_name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (upload_id => uploads.id)
#
class UploadFile < ApplicationRecord
  scope :dangling, -> { where("updated_at < ?", 1.day.ago) }
  belongs_to :upload
  str_enum :status, %i(pending ready)
  validates :file_name, presence: true, uniqueness: { scope: :upload_id }
  has_many :upload_file_chunks, dependent: :delete_all
  has_many :upload_file_logs, dependent: :nullify

  def clean_parent_upload
    upload.destroy if UploadFile.where(upload_id: upload_id).count.zero?
  end
end
