# frozen_string_literal: true

module UploadChunksService
  class UploadChunk
    class Error < StandardError; end
    attr_reader :resumable_identifier, :resumable_filename, :resumable_chunk_number, :resumable_chunk_size, :resumable_total_size,
                :upload_id, :params_file, :upload_file
    def initialize(params, upload_id)
      @resumable_identifier = params[:resumableIdentifier]
      @resumable_filename = params[:resumableFilename]
      @resumable_chunk_number = params[:resumableChunkNumber].to_i
      @resumable_chunk_size = params[:resumableChunkSize].to_i
      @resumable_total_size = params[:resumableTotalSize].to_i
      @params_file = params[:file]
      @upload_id = upload_id
    end

    def handle_chunk
      if resumable_chunk_number == 1
        handle_initial_chunk
      else
        ensure_directory_exists?
        @upload_file = UploadFile.find_by!(upload: upload, file_name: resumable_filename)
      end
      copy_chunk_to_tmp
      self
    end

    def whole_file_ready?
      current_size = resumable_chunk_number * resumable_chunk_size.to_i

      current_size >= resumable_total_size
    end

    def process_whole_file
      upload_file_system.generate_whole_file!
      trigger_bg_process_file
    end

    def whole_file_path
      upload_file_system.path
    end

    private
      def handle_initial_chunk
        unless File.directory?(upload_file_system.upload_dir)
          @upload_file = UploadFile.create!(upload: upload, file_name: resumable_filename)
          return FileUtils.mkdir_p(upload_file_system.upload_dir)
        end

        FileUtils.rm_rf(upload_file_system.upload_dir)
      end

      def copy_chunk_to_tmp
        FileUtils.mv(params_file.tempfile, upload_file_system.chunk_file_path)
      end

      def upload
        return @upload if defined? @upload
        @upload = Upload.find(upload_id)
      end

      def upload_file_system
        @upload_file_system ||= UploadFileSystem.new(upload, resumable_filename, resumable_chunk_number)
      end

      def ensure_directory_exists?
        unless File.directory?(upload_file_system.upload_dir)
          raise Error, "upload path is missing for chunk: #{resumable_chunk_number}"
        end
      end

      def trigger_bg_process_file
      end
  end
end
