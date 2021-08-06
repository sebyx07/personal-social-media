# frozen_string_literal: true

class VirtualFile
  class SaveVirtualFile
    include Memo
    attr_reader :virtual_file, :upload_file
    def initialize(virtual_file, upload_file)
      @virtual_file = virtual_file
      @upload_file = upload_file
    end

    def call
      save_permanent_files.call
      save_cdn_files.call
      self
    end

    def psm_file
      memo(:@psm_file) do
        existing_psm_file = PsmFile.find_by(sha_256: upload_file.client_sha_256)
        return existing_psm_file if existing_psm_file.present?

        PsmFile.new(PsmFile::ExtractAttributesFromFile.new(virtual_file.original_physical_file).attributes).tap do |psm_file|
          psm_file.client_sha_256 = upload_file.client_sha_256
          psm_file.name = upload_file.file_name
          psm_file.save!
        end
      end

    rescue ActiveRecord::RecordInvalid
      upload_file.destroy
      raise
    end

    def psm_original_variant
      @psm_original_variant ||= PsmFileVariant::CreateOriginal.new(psm_file, virtual_file.original_physical_file).save!
    end

    def save_permanent_files
      @save_permanent_files ||= SavePermanentFiles.new(virtual_file, psm_file, psm_original_variant)
    end

    def save_cdn_files
      @save_cdn_files ||= SaveCdnFiles.new(virtual_file, psm_file, psm_original_variant)
    end
  end
end
