# frozen_string_literal: true

require "rails_helper"

RSpec.describe "GET /upload_chunks" do
  include_context "logged in"
  let(:identifier) { SecureRandom.hex }
  let(:file_name) { "example-file.txt" }
  let(:upload) { create(:upload, resumable_upload_identifier: identifier) }
  let(:upload_file) { create(:upload_file, upload: upload) }
  let(:chunk_number) { 1 }
  let(:upload_file_chunk) do
    create(:upload_file_chunk, resumable_chunk_number: chunk_number, upload_file: upload_file)
  end

  let(:params) do
    {
      flowIdentifier: identifier,
      flowFilename: upload_file.file_name,
      flowChunkNumber: chunk_number
    }
  end

  subject do
    get "/upload_chunks/?#{params.to_query}"
  end

  context "valid" do
    before do
      upload_file_chunk
    end

    it "responds ok" do
      subject
      expect(response).to have_http_status(:ok)
    end
  end

  context "invalid" do
    it "responds 404" do
      subject

      expect(response).to have_http_status(404)
    end
  end
end
