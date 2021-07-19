# frozen_string_literal: true

class PsmFileVariant
  class CreateOtherVariantsForImageFile
    attr_reader :psm_file, :original_physical_file
    def initialize(psm_file, original_physical_file)
      @psm_file = psm_file
      @original_physical_file = original_physical_file
    end

    def save!
      %i(xs small mobile large hd).map do |variant_name|
        PsmFileVariant.create!(psm_file: psm_file, variant_name: variant_name).tap do |variant|
          variant.original_physical_file = original_physical_file
        end
      end
    end
  end
end
