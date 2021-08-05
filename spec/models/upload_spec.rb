# frozen_string_literal: true

# == Schema Information
#
# Table name: uploads
#
#  id                          :bigint           not null, primary key
#  resumable_upload_identifier :string
#  status                      :string           default("pending"), not null
#  subject_type                :string           not null
#  upload_files_count          :integer          default(0), not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  subject_id                  :bigint           not null
#
# Indexes
#
#  index_uploads_on_subject  (subject_type,subject_id)
#
require "rails_helper"

RSpec.describe Upload, type: :model do
end
