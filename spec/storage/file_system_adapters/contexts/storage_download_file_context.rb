# frozen_string_literal: true

RSpec.shared_examples "storage download context" do
  let(:test_file_path) { Rails.root.join("spec/support/resources/picture.jpg") }
  let(:file_path) { test_file_path }
  let(:instance) do
    described_class.new
  end

  describe "#download_file" do
    let(:upload_file) do
      FileSystemAdapters::UploadFile.new(filename, file)
    end

    subject do
      instance.upload(upload_file)
      instance.download_file(filename)
    end

    it "it returns a file" do
      expect(subject).to be_a(File)
    end
  end

  describe "#download_files" do
    let(:filenames) { 4.times.map { SecureRandom.hex } }

    let(:upload_files) do
      filenames.map do |filename|
        FileSystemAdapters::UploadFile.new(filename, file)
      end
    end

    subject do
      instance.upload_multi(upload_files)
      instance.download_files(filenames)
    end

    it "downloads multiple files" do
      expect(subject).to be_present
      expect(subject).to be_a(Hash)

      subject.each do |_, file|
        expect(file).to be_a(File)
      end
    end
  end
end
