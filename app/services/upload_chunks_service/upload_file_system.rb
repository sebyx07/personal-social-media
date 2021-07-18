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
      File.exist?(chunk_file_path)
    end

    def upload_dir
      @upload_dir ||= "/tmp/psm-upload/#{upload.resumable_upload_identifier}"
    end

    def chunk_file_path
      @chunk_file_path ||= generate_chunk_file_path(resumable_chunk_number)
    end

    def path
      @path ||= upload_dir + "/#{upload_file_record.file_name}"
    end

    def generate_whole_file!
      return if @generated_whole_file if defined? @generated_whole_file
      chunk_file_list = (1..resumable_chunk_number).map do |part|
        generate_chunk_file_path(part)
      end

      File.open(path, "wb") do |output|
        chunk_file_list.each do |f|
          File.open(f, "rb") do |input|
            output.write(input.read)
          end
          File.delete(f)
        end
      end
      @generated_whole_file = true
    end

    def upload_file_record
      return @upload_file_record if defined? @upload_file_record
      @upload_file_record = UploadFile.find_or_initialize_by(upload: upload, file_name: resumable_filename)
    end

    private
      def generate_chunk_file_path(chunk_number)
        path + ".part#{chunk_number}"
      end
  end
end
