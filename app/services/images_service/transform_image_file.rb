# frozen_string_literal: true

module ImagesService
  class TransformImageFile
    class InvalidImage < StandardError; end
    attr_reader :image_file, :height, :width, :quality
    def initialize(image_file, size:, quality:)
      @image_file = image_file
      @height = size[:height]
      @width = size[:width]
      @quality = quality
    end

    def call
      raise InvalidImage, "invalid image" unless ImageProcessing::Vips.valid_image?(image_file)
      vips_instance
        .resize_to_limit(width, height)
        .saver(strip: true, quality: quality)
        .convert("webp")
        .call
    end

    def vips_instance
      @vips_instance = ImageProcessing::Vips.source(image_file)
    end
  end
end
