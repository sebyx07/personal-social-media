# frozen_string_literal: true

RSpec.shared_examples "storage upload context" do
  let(:test_file_path) { Rails.root.join("spec/support/resources/picture.jpg") }
  let(:file_path) { test_file_path }

  describe "#upload" do
    let(:filename) { SecureRandom.hex }

    let(:upload_file) do
      FileSystemAdapters::UploadFile.new(filename, file)
    end

    subject do
      described_class.new.upload(upload_file)
    end

    it "uploads the file" do
      subject

      expect(described_class.new.exists?(filename)).to be_truthy
    end
  end

  describe "#upload_multi" do
    let(:filenames) { 4.times.map { SecureRandom.hex } }

    let(:upload_files) do
      filenames.map do |filename|
        FileSystemAdapters::UploadFile.new(filename, file)
      end
    end

    subject do
      described_class.new.upload_multi(upload_files)
    end

    it "uploads multiple files" do
      subject
      filenames.each do |filename|
        expect(described_class.new.exists?(filename)).to be_truthy
      end
    end
  end
end
