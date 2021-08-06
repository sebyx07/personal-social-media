# frozen_string_literal: true

module ExifService
  class ExtractGpsCoordinates
    attr_reader :latitude, :longitude
    def initialize(lat:, lng:)
      @latitude = lat
      @longitude = lng
    end

    def call
      return  {} if latitude.blank? || longitude.blank?

      {
        lat: geo_float(*latitude),
        lng: geo_float(*longitude)
      }
    end

    private
      def geo_float(degrees, minutes, seconds)
        degrees + minutes / 60.0 + seconds / 3600.0
      end
  end
end
