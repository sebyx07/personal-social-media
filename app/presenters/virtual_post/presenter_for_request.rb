# frozen_string_literal: true

class VirtualPost
  class PresenterForRequest
    class Error < StandardError; end
    delegate :cache_reactions, :cache_comments, to: :remote_post
    attr_reader :request_helper_cache

    def initialize(request, peer, request_helper_cache)
      @request = request
      @post = request.json[:post]
      @peer = peer
      @request_helper_cache = request_helper_cache
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

    def latest_comments
      return @latest_comments if defined? @latest_comments

      @latest_comments = @post[:latest_comments].map do |json|
        CommentsService::FakeCommentRemote.new(json)
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

    def is_valid_signature?
      return @is_valid_signature if defined? @is_valid_signature
      raw_signature = PostsService::RawSignature.new(self, @peer)

      signed_result = EncryptionService::SignedResult.from_json({
        message: raw_signature.hash.to_s,
        signature: @post[:signature]
      }.with_indifferent_access)

      @is_valid_signature = EncryptionService::VerifySignature.new(@peer.verify_key).verify(signed_result)
    end
  end
end
