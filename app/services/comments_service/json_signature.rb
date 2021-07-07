# frozen_string_literal: true

module CommentsService
  class JsonSignature
    attr_reader :comment
    def initialize(comment)
      @comment = comment
    end

    def call
      EncryptionService::EncryptedContentTransform.to_json(
        call_raw_str
      )
    end

    def call_raw_str
      EncryptionService::Sign.new.sign_message(comment.raw_signature.hash.to_s).signature
    end

    if Rails.env.test?
      def call_test(signing_key)
        EncryptionService::EncryptedContentTransform.to_json(
          call_test_raw_str(signing_key)
        )
      end

      def call_test_raw_str(signing_key)
        EncryptionService::Sign.new._test_sign_message(comment.raw_signature.hash.to_s, signing_key).signature
      end
    end
  end
end
