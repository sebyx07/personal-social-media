# frozen_string_literal: true

module ImagesService
  class TransformImage
    attr_reader :image_file, :height, :width
    def initialize(image_file, size:)
      @image_file = image_file
      @height = size[:height]
      @width = size[:width]
      @options = options
    end

    def call
    end
  end
end
