# frozen_string_literal: true

module PsmFilesService
  module Utils
    module Metadata
      class ExtractFromImage
        attr_reader :image_file
        def initialize(image_file)
          @image_file = image_file
        end

        def call
          {
            height: vips_image.height,
            width: vips_image.width
          }
        end

        private
          def vips_image
            @vips_image ||= Vips::Image.new_from_file(image_file.path)
          end
      end
    end
  end
end
