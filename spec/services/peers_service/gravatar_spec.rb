# frozen_string_literal: true

require "rails_helper"

RSpec.describe PeersService::Gravatar do
  let(:valid_result_url) { "//www.gravatar.com/avatar/23463b99b62a72f26ed677cc556c44e8" }
  context "when email" do
    subject { described_class.new(email: "example@example.com").url }

    it "returns gravatar url" do
      expect(subject).to eq valid_result_url
    end
  end

  context "when email_hexdigest" do
    subject { described_class.new(email_hexdigest: "23463b99b62a72f26ed677cc556c44e8").url }

    it "returns gravatar url" do
      expect(subject).to eq valid_result_url
    end
  end
end
