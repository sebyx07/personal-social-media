# frozen_string_literal: true

class VirtualReaction
  class PresenterForJson
    def initialize(json)
      @json = json
    end

    VirtualReaction::PERMITTED_DELEGATED_METHODS.each do |method_name|
      define_method method_name do
        @json[method_name]
      end
    end

    def id
      @json[:id]
    end

    def peer
      @peer ||= PeersService::FakePeerRemote.new(@json[:peer])
    end
  end
end
