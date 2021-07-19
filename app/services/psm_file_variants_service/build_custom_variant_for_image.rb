# frozen_string_literal: true

module PsmFileVariantsService
  class BuildCustomVariantForImage
    attr_reader :psm_file_variant
    delegate :original_physical_file, :variant_name, to: :psm_file_variant
    def initialize(psm_file_variant)
      @psm_file_variant = psm_file_variant
    end

    def call
      option = options[variant_name.to_sym]
      size = option.slice(:width, :height)

      ImagesService::TransformImageFile.new(original_physical_file, size: size, quality: option[:quality]).call
    end

    private
      def options
        {
          xs: {
            width: 100,
            height: 100,
            qualify: 80
          },
          small: {
            width: 350,
            height: 350,
            qualify: 90
          },
          mobile: {
            width: 800,
            height: 800,
            qualify: 90
          },
          large: {
            width: 1600,
            height: 1600,
            qualify: 90
          },
          hd: {
            width: 2400,
            height: 2400,
            qualify: 100
          }
        }
      end
  end
end
