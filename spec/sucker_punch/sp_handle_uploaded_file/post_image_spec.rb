# frozen_string_literal: true

require "rails_helper"

RSpec.describe SpHandleUploadedFileJob do
  describe "Post with an image attached" do
    let(:permanent_storage) { create(:permanent_storage_provider, :local) }
    let(:cdn_storage) { create(:cdn_storage_provider, :local) }
    let(:psm_file) { post.psm_files.last }
    let(:psm_file_variants) { post.psm_file_variants }
    before do
      permanent_storage
      cdn_storage
    end

    let(:post) { create(:post, status: :pending) }
    let(:upload) { create(:upload, subject: post) }
    let(:upload_file) do
      create(:upload_file, upload: upload)
    end

    let(:file_path) do
      "/tmp/psm-upload/#{SecureRandom.hex}.jpg".tap do |new_path|
        FileUtils.cp(Rails.root.join("spec/support/resources/picture-with-exif.jpg").to_s, new_path)
      end
    end

    subject do
      described_class.new.perform(file_path, upload_file.id)
    end

    it "attaches the image to the post and updates content" do
      expect do
        subject
        post.reload
      end.to change { post.psm_attachments.count }.by(1)
        .and change { post.psm_file_variants.count }.by(6)
        .and change { post.psm_permanent_files.count }.by(1)
        .and change { post.psm_cdn_files.count }.by(6)

      expect(psm_file.metadata.dig("exif", "gps")).to be_present

      psm_file_variants.each do |variant|
        expect(variant.variant_metadata["height"]).to be_present
        expect(variant.variant_metadata["width"]).to be_present
      end

      expect(post.ready?).to be_truthy
    end
  end
end
