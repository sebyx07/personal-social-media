# frozen_string_literal: true

class VirtualPost
  class PresenterForRequest
    def initialize(request, peer)
      @post = request.json[:post]
      @peer = peer
    end

    VirtualPost::PERMITTED_DELEGATED_METHODS.each do |method_name|
      define_method method_name do
        @post[method_name]
      end
    end

    def reaction_counters
      return @reaction_counters if defined? @reaction_counters

      @reaction_counters = post[:reaction_counters].map do |json|
        ReactionCounter.new(json)
      end
    end
  end
end
