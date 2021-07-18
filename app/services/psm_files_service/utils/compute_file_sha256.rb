# frozen_string_literal: true

module PsmFilesService
  module Utils
    class ComputeFileSha256
      attr_reader :file, :buffer_size
      def initialize(file, buffer_size: 2.megabytes)
        @file = file
        @buffer_size = buffer_size
      end

      def call
        ReadFileAsStream.new(file, buffer_size).read do |input|
          digest.update(input)
        end

        digest.hexdigest
      end

      def digest
        @digest ||= Digest::SHA256.new
      end
    end
  end
end
