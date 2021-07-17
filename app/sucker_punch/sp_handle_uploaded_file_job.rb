# frozen_string_literal: true

class SpHandleUploadedFileJob
  include SuckerPunch::Job

  attr_reader :upload_file_record, :psm_file, :virtual_file
  def perform(uploaded_file_path, upload_file_id)
    @uploaded_file_path = uploaded_file_path
    @upload_file_record = UploadFile.find_by(id: upload_file_id)
    return if upload_file_record.blank?

    create_psm_file_record
    # upload_to_permanent_storages
    # upload_to_cdns
    #
    # mark_upload_file_as_ready
    # if all_attachments_ready?
    #   mark_upload_as_ready
    #   update_subject_content
    #   mark_subject_as_ready
    # end
  ensure
    uploaded_file.close
  end

  private
    def mark_upload_file_as_ready
      upload_file_record.update!(status: :ready)
    end

    def create_psm_file_record
      @virtual_file = VirtualFile.new(original_physical_file: uploaded_file).tap do |v_file|
        v_file.save!(upload_file_record.upload.subject)
      end
      @psm_file = virtual_file.psm_file
    end

    def uploaded_file
      File.open(@uploaded_file_path)
    end
end
