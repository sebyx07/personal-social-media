# frozen_string_literal: true

require "rails_helper"

RSpec.describe PsmFilesService::Utils::Exif::ExtractExifFromImage do
  let(:file) do
    File.open(Rails.root.join("spec/support/resources/picture-with-exif.jpg"))
  end

  after do
    file.close
  end

  subject do
    described_class.new(file).call
  end

  it "extracts the exif data from the image" do
    expect(subject[:gps][:lat]).to be_present
    expect(subject[:gps][:lng]).to be_present
  end
end
