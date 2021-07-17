# frozen_string_literal: true

module EncryptionService
  class DecryptFile
    attr_reader :file_path, :output_path, :key, :iv
    def initialize(file_path, output_path, key, iv)
      @file_path = file_path
      @output_path = output_path
      @key = key
      @iv = iv
    end

    class << self
      def js_decryptor
        @js_decryptor ||= DecryptFileSchmooze.new(__dir__)
      end
    end

    def call!
      js_decrypt
    end

    private
      def js_decrypt
        key_bytes = EncryptionService::EncryptedContentTransform.to_json(key)
        iv_bytes = EncryptionService::EncryptedContentTransform.to_json(iv)

        self.class.js_decryptor.decrypt(file_path, output_path, key_bytes, iv_bytes)

        DecryptedFile.new(output_path)
      end
  end
end
