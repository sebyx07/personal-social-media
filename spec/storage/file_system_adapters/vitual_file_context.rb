# frozen_string_literal: true

RSpec.shared_examples "virtual file management" do
  let(:base_cassette_name) { "storage/virtual_file/#{described_class}/" }
  let(:file_path) { Rails.root.join("spec/support/resources/picture.jpg") }
  let(:file) { File.open(file_path) }
  let(:record) { create(:peer) }
  around do |ex|
    VCR.use_cassette(cassette_name) do
      ex.run
    end
  end

  describe "upload" do
    let(:cassette_name) { base_cassette_name + "upload" }

    subject do
      VirtualFile.new(original_physical_file: file).save!
    end

    it "uploads file", vcr: { record: :once, match_requests_on: [] } do
      subject
    end
  end
end
