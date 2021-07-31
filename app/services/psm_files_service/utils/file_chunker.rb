# frozen_string_literal: true

module PsmFilesService
  module Utils
    class FileChunker
      attr_reader :input_path, :output, :chunk_size
      def initialize(input_path, chunk_size)
        @input_path = input_path
        @chunk_size = chunk_size
        @output = []
      end

      def call!
        SafeFile.open(input_path, "rb") do |fh_in|
          ReadFileAsStream.new(fh_in, chunk_size).read do |input|
            output << Tempfile.new.tap do |tmp_file|
              tmp_file.binmode
              tmp_file.write(input)
              tmp_file.rewind
            end
          end
        end

        output
      end

      def clean
        FileUtils.rm_f(output.map(&:path))
      end
    end
  end
end
