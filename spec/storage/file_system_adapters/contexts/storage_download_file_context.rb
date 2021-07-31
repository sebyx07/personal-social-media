# frozen_string_literal: true

RSpec.shared_examples "storage download context" do
  let(:test_file_path) { Rails.root.join("spec/support/resources/picture.jpg") }
  let(:file_path) { test_file_path }

  describe "#download_file" do
    around do |ex|
      VCR.use_cassette("storage/#{described_class}/download") do
        ex.run
      end
    end

    let(:upload_file) do
      FileSystemAdapters::UploadFile.new(filename, file)
    end

    subject do
      instance.upload(upload_file)
      instance.download_file(filename)
    end

    it "it returns a file", vcr: { record: :once, match_requests_on: [], preserve_exact_body_bytes: true } do
      expect(subject).to be_a(File)
    end
  end

  describe "#download_files" do
    around do |ex|
      VCR.use_cassette("storage/#{described_class}/download_files") do
        ex.run
      end
    end

    let(:upload_files) do
      filenames.map do |filename|
        FileSystemAdapters::UploadFile.new(filename, file)
      end
    end

    subject do
      instance.upload_multi(upload_files)
      instance.download_files(filenames)
    end

    it "downloads multiple files", vcr: { record: :once, match_requests_on: [], preserve_exact_body_bytes: true } do
      expect(subject).to be_present
      expect(subject).to be_a(Hash)

      subject.each do |_, file|
        expect(file).to be_a(File)
      end
    end
  end
end
