# frozen_string_literal: true

module EncryptionService
  class EncryptFile
    class EncryptedFile
      attr_reader :path, :key, :iv
      def initialize(path, key, iv)
        @path = path
        @key = key
        @iv = iv
      end
    end
  end
end
