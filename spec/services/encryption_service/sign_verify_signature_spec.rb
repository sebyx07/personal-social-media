# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sign and verify signature with ruby objects" do
  describe "it signs string" do
    let(:message) { "my_message" }
    let(:signature) { EncryptionService::Sign.new.sign_message(message) }
    let(:verify_key) { Current.profile.signing_key.verify_key.to_s }
    let(:verification) { EncryptionService::VerifySignature.new(verify_key).verify(signature) }

    it "verifies successfully" do
      expect(verification).to be_truthy
    end
  end
end
