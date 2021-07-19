# frozen_string_literal: true

class PsmFileVariant
  class CreateOtherVariantsForFile
    attr_reader :psm_file, :original_physical_file
    def initialize(psm_file, original_physical_file)
      @psm_file = psm_file
      @original_physical_file = original_physical_file
    end

    def save!
      if psm_file.type == :image
        CreateOtherVariantsForImageFile.new(psm_file, original_physical_file).save!
      else
        []
      end
    end
  end
end
