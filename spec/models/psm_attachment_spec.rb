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
require "rails_helper"

RSpec.describe PsmAttachment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
