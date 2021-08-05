# frozen_string_literal: true

module FileWorker
  class HandleUploadedFileWorker < ApplicationWorker
    sidekiq_options retry: 0

    attr_reader :upload_file_record, :psm_file, :virtual_file, :psm_attachment, :subject
    delegate :upload, to: :upload_file_record
    def perform(upload_file_id)
      @upload_file_record = UploadFile.find_by(id: upload_file_id)
      return if upload_file_record.blank?
      log_start_job

      @subject = upload.subject

      create_psm_file_record
      mark_upload_file_as_ready!

      return log_end_job(:ok) unless all_upload_files_ready?

      update_subject!
      destroy_upload!

      log_end_job(:ok)
    rescue StandardError
      log_end_job(:error)
      raise
    end

    private
      def mark_upload_file_as_ready!
        upload_file_record.update!(status: :ready)
        psm_file.update!(cdn_storage_status: :ready, permanent_storage_status: :ready)
      end

      def create_psm_file_record
        @virtual_file = VirtualFile.new(original_physical_file: uploaded_file, upload_file: upload_file_record).tap do |v_file|
          v_file.save!
        end
        @psm_file = virtual_file.psm_file
        @psm_attachment = PsmAttachment.create!(psm_file: psm_file, subject: subject)

      rescue ActiveRecord::RecordInvalid => e
        log_message(:error, e.record.errors.full_messages)
        raise
      end

      def uploaded_file
        return @uploaded_file if defined? @uploaded_file
        path = SafeTempfile.generate_new_temp_file_path
        SafeFile.open(path, "wb") do |f|
          upload_file_chunks do |chunks|
            chunks.each do |chunk|
              f.write(chunk.payload)
            end
          end
        end

        @uploaded_file = SafeFile.open(path)
      end

      def upload_file_chunks
        upload_file_record.upload_file_chunks.order(:resumable_chunk_number).find_in_batches(batch_size: 50) do |upload_file_chunks|
          yield upload_file_chunks
        end
      end

      def all_upload_files_ready?
        upload.upload_files.where.not(status: :ready).count.zero?
      end

      def update_subject!
        subject.update!(status: :ready)
      end

      def destroy_upload!
        upload.destroy
      end

      def log_start_job
        log_message(:ok, "Start upload processing job")
      end

      def log_end_job(status)
        log_message(status, "End upload processing job", upload_file: nil)
      end

      def log_message(status, message, upload_file: upload_file_record)
        UploadFileLog.create_log!(upload_file_record.file_name, upload_file: upload_file, log_status: status, message: message)
      end
  end
end
