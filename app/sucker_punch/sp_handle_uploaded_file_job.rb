# frozen_string_literal: true

class SpHandleUploadedFileJob
  include SuckerPunch::Job

  attr_reader :upload_file_record, :psm_file, :virtual_file, :psm_attachment, :subject
  def perform(uploaded_file_path, upload_file_id)
    @uploaded_file_path = uploaded_file_path
    @upload_file_record = UploadFile.find_by(id: upload_file_id)
    return if upload_file_record.blank?

    @subject = upload_file_record.upload.subject

    create_psm_file_record
    mark_upload_file_as_ready!

    return unless all_upload_files_ready?

    update_subject!
  ensure
    uploaded_file.close
    File.delete(uploaded_file.path)
  end

  private
    def mark_upload_file_as_ready!
      upload_file_record.update!(status: :ready)
    end

    def create_psm_file_record
      @virtual_file = VirtualFile.new(original_physical_file: uploaded_file).tap do |v_file|
        v_file.save!
      end
      @psm_file = virtual_file.psm_file
      @psm_attachment = PsmAttachment.create!(psm_file: psm_file, subject: subject)
    end

    def uploaded_file
      File.open(@uploaded_file_path)
    end

    def all_upload_files_ready?
      upload_file_record.upload.upload_files.where.not(status: :ready).count.zero?
    end

    def update_subject!
      subject.update!(status: :ready)
    end
end
