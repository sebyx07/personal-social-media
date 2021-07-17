# frozen_string_literal: true

require "rails_helper"

RSpec.describe SpHandleUploadedFileJob do
  describe "Post with an image attached" do
    let(:post) { create(:post) }
    let(:upload) { create(:upload, subject: post) }
    let(:upload_file) do
      create(:upload_file, upload: upload)
    end

    let(:file_path) do
      "/tmp/psm-upload/#{SecureRandom.hex}.jpg".tap do |new_path|
        FileUtils.cp(Rails.root.join("spec/support/resources/picture.jpg"), new_path)
      end
    end

    subject do
      described_class.new.perform(file_path, upload_file.id)
    end

    xit "attaches the image to the post and updates content" do
      expect do
        subject
      end.to change { post.psm_files.count }.by(1)
    end
  end
end
