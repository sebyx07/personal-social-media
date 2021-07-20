# frozen_string_literal: true

module PsmFilesService
  module Utils
    module Exif
      class ExtractExifFromImage
        attr_reader :image_file
        def initialize(image_file)
          @image_file = image_file
        end

        def call
          return {} if exif_data.blank?
          {
            gps: gps_location
          }
        end

        def exif_data
          @exif_data ||= ::Exif::Data.new(image_file)

        rescue ::Exif::NotReadable
          nil
        end

        def gps_location
          ExifService::ExtractGpsCoordinates.new(lat: exif_data.gps_latitude, lng: exif_data.gps_longitude).call
        end
      end
    end
  end
end
