# frozen_string_literal: true

class VirtualFile
  class SaveVirtualFile
    include Memo
    attr_reader :virtual_file, :subject
    def initialize(virtual_file, subject)
      @virtual_file = virtual_file
      @subject = subject
    end

    def call
      save_permanent_files.call
      save_cdn_files.call
      self
    end

    def psm_file
      memo(:@psm_file) do
        PsmFile.new(PsmFile::ExtractAttributesFromFile.new(virtual_file.original_physical_file).attributes).tap do |psm_file|
          psm_file.subject = subject
          psm_file.save!
        end
      end
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
