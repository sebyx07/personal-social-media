# frozen_string_literal: true

require "rails_helper"

RSpec.describe ArchiveService::ProtectedArchive do
  describe "archives and unarchives this spec file" do
    let(:file_path) { __FILE__ }
    let(:file) { SafeFile.open(file_path) }
    let(:password) { "1234" }

    describe "#generate_archive" do
      let(:protected_archive) { described_class.new(file: file, password: password, file_name: file_path.split("/").last) }
      subject do
        protected_archive.generate_archive
      end

      it "generates a new archive" do
        expect(subject).to be_a(File)
      end
    end

    describe "#extract_archive" do
      let(:protected_archive) { described_class.new(file: file, password: password, file_name: file_path.split("/").last) }
      let(:archive) do
        protected_archive.generate_archive
      end
      let(:protected_archive_extractor) do
        described_class.new(archive: archive, password: password)
      end

      subject do
        protected_archive_extractor.extract_archive
      end

      it "returns the file extracted" do
        expect(subject).to be_a(File)
      end
    end
  end
end
