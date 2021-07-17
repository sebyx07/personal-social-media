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
        File.open(input_path, "r") do |fh_in|
          until fh_in.eof?
            tmp_file = Tempfile.new
            output << tmp_file
            tmp_file.write(fh_in.read(chunk_size))
            tmp_file.rewind
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
