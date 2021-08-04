# frozen_string_literal: true

module UploadChunksService
  class UploadChunk
    class Error < StandardError; end
    attr_reader :resumable_identifier, :resumable_filename, :resumable_chunk_number, :resumable_chunk_size, :resumable_total_size,
                :upload_id, :params_file, :upload_file, :upload_file_chunk, :resumable_total_chunks
    def initialize(params, upload_id)
      @resumable_identifier = params[:flowIdentifier]
      @resumable_filename = params[:flowFilename]
      @resumable_chunk_number = params[:flowChunkNumber].to_i
      @resumable_total_chunks = params[:flowTotalChunks].to_i
      @resumable_chunk_size = params[:flowChunkSize].to_i
      @resumable_total_size = params[:flowTotalSize].to_i
      @params_file = params[:file]
      @upload_id = upload_id
    end

    def handle_chunk
      @upload_file = UploadFile.find_by!(upload: upload, file_name: resumable_filename, status: :pending)
      create_chunk!
      self
    end

    def whole_file_ready?
      upload_file.upload_file_chunks.count == resumable_total_chunks
    end

    def process_whole_file
      trigger_bg_process_file
      UploadFileLog.create_log!(upload_file.file_name, upload_file: upload_file, log_status: :ok, message: "Enqueue upload processing job")
    end

    private
      def create_chunk!
        File.open(params_file.tempfile.path, "rb") do |f|
          @upload_file_chunk = UploadFileChunk.create!(
            upload_file: upload_file, resumable_chunk_number: resumable_chunk_number,
            payload: f.read
          )
        end
      end

      def upload
        return @upload if defined? @upload
        @upload = Upload.find(upload_id)
      end

      def trigger_bg_process_file
        FileWorker::HandleUploadedFileWorker.perform_async(upload_file.id)
      end
  end
end
