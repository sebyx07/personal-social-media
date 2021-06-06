# frozen_string_literal: true

class VirtualPost
  class PresenterForRequest
    class Error < StandardError; end
    delegate :cache_reactions, to: :remote_post

    def initialize(request, peer)
      @request = request
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

      @reaction_counters = @post[:reaction_counters].map do |json|
        ReactionCounter.new(json)
      end
    end

    def remote_post
      return @remote_post if defined? @remote_post
      record_result = @request.record
      return @remote_post = record_result if record_result.is_a?(RemotePost)

      raise Error, "invalid @request.record, #{record_result}" if record_result.blank?

      post_id = id
      @remote_post = record_result.detect do |remote_post|
        remote_post.remote_post_id == post_id
      end
    end
  end
end
