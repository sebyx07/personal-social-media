# frozen_string_literal: true

RSpec.shared_examples "storage resolve url context" do
  let(:test_file_path) { Rails.root.join("spec/support/resources/picture.jpg") }
  let(:file_path) { test_file_path }

  describe "#resolve_url_for_file" do
    around do |ex|
      VCR.use_cassette("storage/#{described_class}/resolve_url") do
        ex.run
      end
    end

    let(:upload_file) do
      FileSystemAdapters::UploadFile.new(filename, file)
    end

    subject do
      instance.upload(upload_file)
      instance.resolve_url_for_file(filename)
    end

    it "resolves the url for file", vcr: { record: :once, match_requests_on: [], preserve_exact_body_bytes: true } do
      expect(subject).to be_a(String)
    end
  end

  describe "#resolve_urls_for_files" do
    around do |ex|
      VCR.use_cassette("storage/#{described_class}/resolve_urls") do
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
      instance.resolve_urls_for_files(filenames)
    end

    it "resolves the urls for multiple files", vcr: { record: :once, match_requests_on: [], preserve_exact_body_bytes: true } do
      expect(subject).to be_present
      expect(subject).to be_a(Hash)

      subject.keys.each do |url|
        expect(url).to be_a(String)
      end
    end
  end
end
