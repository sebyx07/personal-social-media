# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Encryption and decryption with ruby objects" do
  let(:peer) { build(:peer) }
  let(:profile) { create(:profile) }

  before do
    profile
  end

  describe "encrypts message and can read it back" do
    let(:encrypt) { EncryptionService::Encrypt.new(peer.public_key) }
    let(:decrypt) { EncryptionService::Decrypt.new(peer.public_key) }
    let(:message) { SecureRandom.urlsafe_base64 2048 }
    let(:encrypted_content) { encrypt.encrypt(message) }
    let(:decrypted_content) { decrypt.decrypt(encrypted_content) }

    it "returns wow" do
      expect(encrypted_content.cypher_text).to be_present
      expect(encrypted_content.nonce).to be_present

      expect(message).to eq(decrypted_content)
    end
  end
end
