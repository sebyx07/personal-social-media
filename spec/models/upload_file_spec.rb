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
require "rails_helper"

RSpec.describe UploadFile, type: :model do
end
