# frozen_string_literal: true

# == Schema Information
#
# Table name: psm_attachments
#
#  id           :bigint           not null, primary key
#  subject_type :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  psm_file_id  :bigint           not null
#  subject_id   :bigint           not null
#
# Indexes
#
#  index_psm_attachments_on_psm_file_id  (psm_file_id)
#  index_psm_attachments_on_subject      (subject_type,subject_id)
#
# Foreign Keys
#
#  fk_rails_...  (psm_file_id => psm_files.id)
#
class PsmAttachment < ApplicationRecord
  belongs_to :subject, polymorphic: true
  belongs_to :psm_file
  has_many :psm_file_variants, through: :psm_file
  has_many :psm_permanent_files, through: :psm_file
  has_many :psm_cdn_files, through: :psm_file

  after_destroy :destroy_psm_file_if_no_attachments
  validates :psm_file_id, uniqueness: { scope: %i(subject_type subject_id) }

  private
    def destroy_psm_file_if_no_attachments
      psm_file.destroy if psm_file.psm_attachments.count.zero?
    end
end
