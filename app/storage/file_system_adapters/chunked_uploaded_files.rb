# frozen_string_literal: true

module FileSystemAdapters
  class ChunkedUploadedFiles < BaseAdapter
    CHUNK_SIZE = 1.megabyte

    include Memo
    attr_reader :name, :file
    def initialize(name, file)
      @name = name
      @file = file
    end

    def chunks
      memo(:@chunks) do
        PsmFilesService::Utils::FileChunker.new(file, CHUNK_SIZE).call!
      end
    end

    def uploaded_files
      memo(:@uploaded_files) do
        chunks.each_with_index.map do |chunk, index|
          upload_file_name = generate_upload_file_name(index)

          UploadFile.new(upload_file_name, chunk)
        end
      end
    end

    def generate_upload_file_name(index)
      return name if index < 1

      name + "-p#{index + 1}"
    end
  end
end
