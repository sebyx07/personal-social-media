# frozen_string_literal: true

class PsmFileVariant
  class CreateOriginal
    attr_reader :psm_file
    def initialize(psm_file)
      @psm_file = psm_file
    end

    def save!
      PsmFileVariant.create!(psm_file: psm_file, variant_name: :original)
    end
  end
end
