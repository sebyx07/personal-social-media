# frozen_string_literal: true

module EncryptionService
  class EncryptFile
    attr_reader :file_path, :output_path, :key, :iv
    def initialize(file_path, output_path, key, iv)
      @file_path = file_path
      @output_path = output_path
      @key = key
      @iv = iv
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
        key_bytes = EncryptionService::EncryptedContentTransform.to_json(key)
        iv_bytes = EncryptionService::EncryptedContentTransform.to_json(iv)

        self.class.js_encryptor.encrypt(file_path, output_path, key_bytes, iv_bytes)

        EncryptedFile.new(output_path, key, iv)
      end
  end
end
