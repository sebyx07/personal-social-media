# frozen_string_literal: true

RSpec.shared_examples "storage remove context" do
  let(:test_file_path) { Rails.root.join("spec/support/resources/picture.jpg") }
  let(:file_path) { test_file_path }
  let(:instance) do
    described_class.new.tap do |i|
      i.set_account(account)
    end
  end

  describe "#remove" do
    around do |ex|
      VCR.use_cassette("storage/#{described_class}/remove") do
        ex.run
      end
    end

    let(:upload_file) do
      FileSystemAdapters::UploadFile.new(filename, file)
    end

    subject do
      instance.upload(upload_file)
      instance.remove(filename)
    end

    it "removes the file", vcr: { record: :once, match_requests_on: [], preserve_exact_body_bytes: true } do
      subject

      expect(instance.exists?(filename)).to be_falsey
    end
  end

  describe "#remove_multi" do
    around do |ex|
      VCR.use_cassette("storage/#{described_class}/remove_multi") do
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
      instance.remove_multi(filenames)
    end

    it "removes multiple files", vcr: { record: :once, match_requests_on: [], preserve_exact_body_bytes: true } do
      subject
      filenames.each do |filename|
        expect(instance.exists?(filename)).to be_falsey
      end
    end
  end
end
