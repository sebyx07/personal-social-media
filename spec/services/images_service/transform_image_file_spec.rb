# frozen_string_literal: true

require "rails_helper"

RSpec.describe ImagesService::TransformImageFile do
  describe "#call" do
    let(:image_file_path) do
      "/tmp/psm-upload/#{SecureRandom.hex}.jpg".tap do |new_path|
        FileUtils.cp(Rails.root.join("spec/support/resources/picture.jpg").to_s, new_path)
      end
    end

    let(:image_file) do
      SafeFile.open(image_file_path)
    end

    after do
      File.delete(subject.path)
    end

    subject do
      described_class.new(image_file, size: { height: 100, width: 100 }, quality: 100).call
    end

    it "transforms the image" do
      expect(subject).to be_a(Tempfile)

      expect(File.exist?(subject.path))
    end
  end
end
