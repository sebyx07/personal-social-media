# frozen_string_literal: true

require "rails_helper"

RSpec.describe PsmFilesService::Utils::Metadata::ExtractFromImage do
  let(:file) do
    File.open(Rails.root.join("spec/support/resources/picture.jpg"))
  end

  after do
    file.close
  end

  subject do
    described_class.new(file).call
  end

  it "extracts the metadata from the image" do
    expect(subject[:height]).to be_present
    expect(subject[:width]).to be_present
  end
end
