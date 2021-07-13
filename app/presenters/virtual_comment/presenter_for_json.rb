# frozen_string_literal: true

class VirtualComment
  class PresenterForJson
    delegate :cache_reactions, to: :@request_helper_cache

    def initialize(json, request_helper_cache)
      @json = json
      @request_helper_cache = request_helper_cache
    end

    VirtualComment::PERMITTED_DELEGATED_METHODS.each do |method_name|
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

    def reaction_counters
      return @reaction_counters if defined? @reaction_counters

      @reaction_counters = @json[:reaction_counters].map do |json|
        ReactionCounter.new(json)
      end
    end
  end
end
