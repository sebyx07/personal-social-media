# frozen_string_literal: true

module InstantUploadFilesService
  class CreateNewInstantUpload
    attr_reader :create_params, :status
    def initialize(create_params)
      @create_params = create_params
    end

    def call!
      if psm_file.present?
        handle_instant_upload
      else
        handle_new_upload_file
      end

      upload_file
    end

    def handle_instant_upload
      PsmAttachment.create!(psm_file: psm_file, subject: upload.subject)
      @status = :ready
    end

    def psm_file
      @psm_file ||= PsmFile.find_by(sha_256: create_params[:sha256])
    end

    def upload
      @upload ||= Upload.find(create_params[:upload_id])
    end

    def upload_file
      return @upload_file if defined? @upload_file
      @upload_file = UploadFile.find_or_initialize_by(upload: upload, client_sha_256: create_params[:sha256])
      return @upload_file if @upload_file.persisted?
      @upload_file.tap do |upload_file|
        upload_file.status = status
        upload_file.file_name = create_params[:file_name]
        upload_file.save!
      end

    rescue ActiveRecord::RecordNotUnique
      UploadFile.find_by!(upload: upload, client_sha_256: create_params[:sha256])
    end

    def handle_new_upload_file
      @status = :pending
    end
  end
end
