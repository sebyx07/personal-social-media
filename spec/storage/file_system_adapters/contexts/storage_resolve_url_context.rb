# frozen_string_literal: true

RSpec.shared_examples "storage resolve url context" do
  let(:test_file_path) { Rails.root.join("spec/support/resources/picture.jpg") }
  let(:file_path) { test_file_path }
  let(:instance) do
    described_class.new
  end

  describe "#resolve_url_for_file" do
    let(:filename) { SecureRandom.hex }

    let(:upload_file) do
      FileSystemAdapters::UploadFile.new(filename, file)
    end

    subject do
      instance.upload(upload_file)
      instance.resolve_url_for_file(filename)
    end

    it "resolves the url for file" do
      expect(subject).to be_present
    end
  end

  describe "#resolve_urls_for_files" do
    let(:filenames) { 4.times.map { SecureRandom.hex } }

    let(:upload_files) do
      filenames.map do |filename|
        FileSystemAdapters::UploadFile.new(filename, file)
      end
    end

    subject do
      instance.upload_multi(upload_files)
      instance.resolve_urls_for_files(filenames)
    end

    it "resolves the urls for multiple files" do
      expect(subject).to be_present
      expect(subject).to be_a(Hash)
    end
  end
end
