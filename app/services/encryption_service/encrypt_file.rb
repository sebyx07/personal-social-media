# frozen_string_literal: true

module EncryptionService
  class EncryptFile
    attr_reader :file_path, :output_path
    def initialize(file_path, output_path)
      @file_path = file_path
      @output_path = output_path
    end

    class << self
      def js_encryptor
        @js_encryptor ||= EncryptFileSchmooze.new(__dir__)
      end
    end

    def call!
      js_encrypt
    end

    private
      def js_encrypt
        output = self.class.js_encryptor.encrypt(file_path, output_path)
        key = EncryptionService::EncryptedContentTransform.to_str(output.dig("key", "data"))
        iv = EncryptionService::EncryptedContentTransform.to_str(output.dig("iv", "data"))

        EncryptedFile.new(output_path, key, iv)
      end
  end
end
