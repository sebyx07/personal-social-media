# frozen_string_literal: true

RSpec.shared_examples "storage remove context" do
  let(:test_file_path) { Rails.root.join("spec/support/resources/picture.jpg") }
  let(:file_path) { test_file_path }
  let(:instance) do
    described_class.new
  end

  describe "#remove" do
    let(:filename) { SecureRandom.hex }

    let(:upload_file) do
      FileSystemAdapters::UploadFile.new(filename, file)
    end

    subject do
      instance.upload(upload_file)
      instance.remove(filename)
    end

    it "removes the file" do
      subject

      expect(described_class.new.exists?(filename)).to be_falsey
    end
  end

  describe "#remove_multi" do
    let(:filenames) { 4.times.map { SecureRandom.hex } }

    let(:upload_files) do
      filenames.map do |filename|
        FileSystemAdapters::UploadFile.new(filename, file)
      end
    end

    subject do
      instance.upload_multi(upload_files)
      instance.remove_multi(filenames)
    end

    it "removes multiple files" do
      subject
      filenames.each do |filename|
        expect(described_class.new.exists?(filename)).to be_falsey
      end
    end
  end
end
