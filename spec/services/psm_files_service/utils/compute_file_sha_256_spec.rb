# frozen_string_literal: true

require "rails_helper"

RSpec.describe PsmFilesService::Utils::ComputeFileSha256 do
  let(:file) { SafeFile.open(Rails.root.join("spec/support/resources/picture.jpg"), "rb") }
  let(:read_1kb) do
    described_class.new(file, buffer_size: 1.kilobyte).call
  end

  subject do
    described_class.new(file).call
  end

  it "computes the sha of file" do
    expect(subject).to eq("28303e77cdd92ad08e2d746c76f0b901e33fe453015672afb4d9f8e9f5eb252f")
    expect(subject).to eq(read_1kb)
  end
end
