# frozen_string_literal: true

require "rails_helper"

RSpec.describe EncryptionService::DecryptFile do
  describe "#call!" do
    let(:key) { SecureRandom.bytes(32) }
    let(:iv) { SecureRandom.bytes(16) }
    let(:output_encrypted_file_path) { "/tmp/sample-decryption-file" }
    let(:output_decrypted_file_path) { "/tmp/sample-decryption-file-output" }
    let(:test_file_path) do
      Rails.root.join("LICENSE")
    end
    let(:encrypted_file) do
      EncryptionService::EncryptFile.new(test_file_path, output_encrypted_file_path, key, iv).call!
    end
    let(:real_content) do
      File.read(test_file_path)
    end

    subject do
      described_class.new(encrypted_file.path, output_decrypted_file_path, encrypted_file.key, encrypted_file.iv).call!
    end

    after do
      File.delete(output_encrypted_file_path)
      File.delete(output_decrypted_file_path)
    end

    it "encrypts a file" do
      expect(subject).to be_a(EncryptionService::DecryptFile::DecryptedFile)
      expect(subject.read).to eq real_content

      expect(File.exist?(output_decrypted_file_path)).to be_truthy
    end
  end
end
