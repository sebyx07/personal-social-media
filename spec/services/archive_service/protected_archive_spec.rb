# frozen_string_literal: true

require "rails_helper"

RSpec.describe ArchiveService::ProtectedArchive do
  describe "archives and unarchives this spec file" do
    let(:file_path) { __FILE__ }
    let(:file) { SafeFile.open(file_path) }
    let(:password) { "1234" }
    let(:protected_archive) { described_class.new(file: file, password: password, file_name: file_path.split("/").last) }

    subject do
      protected_archive.generate_archive
      protected_archive.extract_archive
    end

    it "is correct" do
      subject
    end
  end
end
