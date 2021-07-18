# frozen_string_literal: true

module PsmFilesService
  module Utils
    class ReadFileAsStream
      attr_reader :file, :chunk_size
      def initialize(file, chunk_size)
        @file = file
        @chunk_size = chunk_size
      end

      def read
        until file.eof?
          yield file.read(@chunk_size)
        end

        file.rewind
      end
    end
  end
end
