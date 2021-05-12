# frozen_string_literal: true

module ProfilesService
  class CreateNewSigningKey
    def call
      signing_key.to_s
    end

    private
      def signing_key
        @signing_key ||= RbNaCl::SigningKey.generate
      end
  end
end
