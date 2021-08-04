# frozen_string_literal: true

require "rails_helper"
require_relative "../../shared_contexts/setup_test_storage"

RSpec.describe "POST /instant_upload_files", type: :request do
  include_context "logged in"
  include_context "setup test storage"

  let(:upload) { create(:upload) }
  let(:file_name) { "Gemfile" }
  let(:sha_256) { SecureRandom.hex }

  let(:params) do
    {
      upload_file: {
        upload_id: upload.id,
        file_name: file_name,
        sha_256: sha_256,
      }
    }
  end

  subject do
    post "/instant_upload_files", params: params
  end

  context "psm_file not uploaded already" do
    it "creates a new pending upload file" do
      expect do
        subject
      end.to change { UploadFile.pending.count }.by(1)
    end
  end

  context "psm_file uploaded already" do
    let(:psm_file) { create(:psm_file, sha_256: sha_256) }
    let(:upload_subject) { upload.subject }

    before do
      psm_file
    end

    it "creates a new ready upload file" do
      expect do
        subject
      end.to change { UploadFile.ready.count }.by(1)
         .and change { upload_subject.psm_attachments.count }.by(1)
    end
  end
end
