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
FactoryBot.define do
  factory :upload do
    status { :pending }
    resumable_upload_identifier { SecureRandom.hex }

    before(:create) do |r|
      r.subject ||= create(:post)
    end
  end
end
