# frozen_string_literal: true

# == Schema Information
#
# Table name: upload_files
#
#  id         :bigint           not null, primary key
#  file_name  :string
#  status     :string           default("pending"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  upload_id  :bigint           not null
#
# Indexes
#
#  index_upload_files_on_upload_id_and_file_name  (upload_id,file_name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (upload_id => uploads.id)
#
FactoryBot.define do
  factory :upload_file do
    upload
    sequence :file_name do |n|
      "file-name-#{n}.txt"
    end
    status { :ready }
  end
end
