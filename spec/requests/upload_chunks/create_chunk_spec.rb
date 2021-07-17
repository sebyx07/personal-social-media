# frozen_string_literal: true

require "rails_helper"

RSpec.describe "POST /upload_chunks", type: :request do
  include_context "logged in"
  let(:input_file) { "Gemfile" }
  let(:input_file_size) { File.size(input_file) }
  let(:chunk_size) { (input_file_size / 3.to_f).ceil }
  let(:chunks) { chunker(input_file, chunk_size) }
  let(:identifier) { SecureRandom.hex }
  let(:upload) { create(:upload) }

  before do
    expect_any_instance_of(UploadChunksService::UploadChunk).to receive(:trigger_bg_process_file).and_return(true)
  end

  it "uploads chunks and processes a whole file" do
    chunks.each_with_index do |chunk, i|
      make_request(chunk, i + 1)

      expect(response).to have_http_status(:ok)
    end
  end

  def chunker(input, chunk_size)
    output_files = []
    File.open(input, "r") do |fh_in|
      until fh_in.eof?
        tmp_file = Tempfile.new
        output_files << tmp_file
        tmp_file.write(fh_in.read(chunk_size))
        tmp_file.rewind
      end
    end

    output_files
  end

  def make_request(chunk, chunk_index)
    params = {
      resumableIdentifier: identifier,
      resumableFilename: input_file,
      resumableChunkNumber: chunk_index,
      file: Rack::Test::UploadedFile.new(chunk, "text/plain"),
      resumableChunkSize: chunk_size,
      resumableTotalSize: input_file_size
    }

    post "/upload_chunks", params: params, headers: { PSM_UPLOAD_ID: upload.id }
  end
end
