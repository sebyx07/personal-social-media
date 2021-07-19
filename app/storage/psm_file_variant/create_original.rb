# frozen_string_literal: true

class PsmFileVariant
  class CreateOriginal
    attr_reader :psm_file, :original_physical_file
    def initialize(psm_file, original_physical_file)
      @psm_file = psm_file
      @original_physical_file = original_physical_file
    end

    def save!
      PsmFileVariant.new(psm_file: psm_file, variant_name: :original).tap do |variant|
        variant.original_physical_file = original_physical_file
        variant.create_variant_file!
        variant.save!
      end
    end
  end
end
