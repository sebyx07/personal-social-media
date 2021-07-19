# frozen_string_literal: true

class VirtualFile
  class SaveVirtualFile
    attr_reader :virtual_file, :subject
    def initialize(virtual_file, subject)
      @virtual_file = virtual_file
      @subject = subject
    end

    def call
      save_permanent_files.call
      self
    end

    def psm_file
      return @psm_file if defined? @psm_file
      @psm_file = PsmFile.new(PsmFile::ExtractAttributesFromFile.new(virtual_file.original_physical_file).attributes).tap do |psm_file|
        psm_file.subject = subject
        psm_file.save!
      end
    end

    def psm_original_variant
      @psm_original_variant ||= PsmFileVariant::CreateOriginal.new(psm_file).save!
    end

    def save_permanent_files
      @save_permanent_files ||= SavePermanentFiles.new(virtual_file, psm_file, psm_original_variant)
    end
  end
end
