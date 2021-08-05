# frozen_string_literal: true

require "rails_helper"
require_relative "../../shared_contexts/setup_test_storage"

RSpec.describe CleanupWorkers::CleanDanglingUploadFilesWorker do
  include_context "setup test storage"

  subject do
    described_class.new.perform
  end

  describe "#perform" do
    let(:upload_file) { create(:upload_file) }

    before do
      upload_file.update!(updated_at: 2.days.ago)
    end

    it "cleans dangling files" do
      expect do
        subject
      end.to change { UploadFile.count }.by(-1)
         .and change { Upload.count }.by(-1)
    end
  end
end
