# frozen_string_literal: true

# == Schema Information
#
# Table name: uploads
#
#  id                          :bigint           not null, primary key
#  resumable_upload_identifier :string
#  status                      :string           default("pending"), not null
#  subject_type                :string           not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  subject_id                  :bigint           not null
#
# Indexes
#
#  index_uploads_on_subject  (subject_type,subject_id)
#
class Upload < ApplicationRecord
  belongs_to :subject, polymorphic: true
  has_many :upload_files, dependent: :destroy
  str_enum :status, %i(pending ready)

  validates :subject_type, inclusion: { in: %w(Post Comment) }
  validates :resumable_upload_identifier, presence: true, on: :update
end
