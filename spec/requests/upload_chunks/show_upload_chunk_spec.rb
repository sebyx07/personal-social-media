# frozen_string_literal: true

require "rails_helper"

RSpec.describe "GET /upload_chunks" do
  include_context "logged in"
  let(:identifier) { SecureRandom.hex }
  let(:file_name) { "example-file.txt" }
  let(:upload) { create(:upload, resumable_upload_identifier: identifier) }
  let(:upload_file) { create(:upload_file, upload: upload) }
  let(:chunk_number) { 1 }

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
    let(:upload_dir) { "/tmp/psm-upload/#{upload.resumable_upload_identifier}" }
    let(:real_file_path) do
      "#{upload_dir}/#{upload_file.file_name}.part#{chunk_number}"
    end

    before do
      FileUtils.mkdir_p(upload_dir)
      FileUtils.touch(real_file_path)
    end

    after do
      File.delete(real_file_path)
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
