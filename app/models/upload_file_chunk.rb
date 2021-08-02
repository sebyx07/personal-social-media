# frozen_string_literal: true

# == Schema Information
#
# Table name: upload_file_chunks
#
#  id                     :bigint           not null, primary key
#  payload                :binary           not null
#  resumable_chunk_number :bigint           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  upload_file_id         :bigint           not null
#
# Indexes
#
#  index_upload_file_chunks_on_upload_id_resumable  (upload_file_id,resumable_chunk_number) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (upload_file_id => upload_files.id)
#
class UploadFileChunk < ApplicationRecord
  belongs_to :upload_file
end
