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
      File.exist?(chunk_file)
    end

    private
      def upload_dir
        @upload_dir ||= "/tmp/psm-upload/#{upload.resumable_upload_identifier}"
      end

      def upload_file
        @upload_file ||= upload_dir + "/#{upload_file_record.file_name}"
      end

      def chunk_file
        @chunk_file ||= upload_file + ".part#{resumable_chunk_number}"
      end

      def upload_file_record
        return @upload_file_record if defined? @upload_file_record
        @upload_file_record = UploadFile.find_or_initialize_by(upload: upload, file_name: resumable_filename)
      end
  end
end
