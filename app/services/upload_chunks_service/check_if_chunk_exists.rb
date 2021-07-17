# frozen_string_literal: true

module UploadChunksService
  class CheckIfChunkExists
    attr_reader :resumable_identifier, :resumable_filename, :resumable_chunk_number
    def initialize(resumable_identifier, resumable_filename, resumable_chunk_number)
      @resumable_identifier = resumable_identifier
      @resumable_filename = resumable_filename
      @resumable_chunk_number = resumable_chunk_number
    end

    def exists?
      return false unless upload.present?
      upload_file_system.exists?
    end

    private
      def upload
        return @upload if defined? @upload
        @upload = Upload.find_by(resumable_upload_identifier: resumable_identifier)
      end

      def upload_file_system
        @upload_file_system ||= UploadFileSystem.new(upload, resumable_filename, resumable_chunk_number)
      end
  end
end
