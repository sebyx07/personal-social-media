# frozen_string_literal: true

require "rails_helper"

RSpec.describe SpHandleUploadedFileJob do
  describe "Post with an image attached" do
    let(:permanent_storage) { create(:permanent_storage_provider, :local) }
    before do
      permanent_storage
      expect_any_instance_of(FileSystemAdapters::LocalFileSystemAdapter).to receive(:upload)
    end

    let(:post) { create(:post) }
    let(:upload) { create(:upload, subject: post) }
    let(:upload_file) do
      create(:upload_file, upload: upload)
    end

    let(:file_path) do
      "/tmp/psm-upload/#{SecureRandom.hex}.jpg".tap do |new_path|
        FileUtils.cp(Rails.root.join("spec/support/resources/picture.jpg").to_s, new_path)
      end
    end

    subject do
      described_class.new.perform(file_path, upload_file.id)
    end

    it "attaches the image to the post and updates content" do
      expect do
        subject
      end.to change { post.psm_files.count }.by(1)
        .and change { post.psm_file_variants.count }.by(1)
        .and change { post.psm_permanent_files.count }.by(1)
    end
  end
end
