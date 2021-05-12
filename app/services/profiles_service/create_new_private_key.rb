# frozen_string_literal: true

module ProfilesService
  class CreateNewPrivateKey
    def call
      private_key.to_s
    end

    private
      def private_key
        @private_key ||= RbNaCl::PrivateKey.generate
      end
  end
end
