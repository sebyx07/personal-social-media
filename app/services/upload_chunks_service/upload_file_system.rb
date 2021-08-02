# frozen_string_literal: true

module UploadChunksService
  class UploadFileSystem
    attr_reader :upload, :resumable_chunk_number, :resumable_filename
    def initialize(upload, resumable_filename, resumable_chunk_number)
      @upload = upload
      @resumable_filename = resumable_filename
      @resumable_chunk_number = resumable_chunk_number
    end

    def exists?
      return false unless upload_file_record.persisted?
      upload_file_record.upload_file_chunks.exists?(resumable_chunk_number: resumable_chunk_number)
    end

    def upload_file_record
      return @upload_file_record if defined? @upload_file_record
      @upload_file_record = UploadFile.find_or_initialize_by(upload: upload, file_name: resumable_filename)
    end
  end
end
