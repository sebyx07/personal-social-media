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
FactoryBot.define do
  factory :psm_attachment do
    psm_file

    before(:create) do |r|
      r.subject ||= create(:post)
    end
  end
end
