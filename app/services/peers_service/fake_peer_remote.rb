# frozen_string_literal: true

module PeersService
  class FakePeerRemote
    ATTRIBUTES = %i(id name nickname avatar public_key verify_key avatar domain_name)

    def initialize(attributes)
      @attributes = attributes
    end

    def is_me
      false
    end

    def status
      []
    end

    ATTRIBUTES.each do |attr|
      define_method attr do
        @attributes[attr]
      end
    end
  end
end
