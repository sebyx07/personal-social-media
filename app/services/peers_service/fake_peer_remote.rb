# frozen_string_literal: true

module PeersService
  class FakePeerRemote
    ATTRIBUTES = %i(id name nickname avatar public_key verify_key)

    def initialize(attributes)
      @attributes = attributes
    end

    ATTRIBUTES.each do |attr|
      define_method attr do
        @attributes[attr]
      end
    end
  end
end
