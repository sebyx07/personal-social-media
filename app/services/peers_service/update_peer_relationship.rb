# frozen_string_literal: true

module PeersService
  class UpdatePeerRelationship
    class Error < StandardError; end
    class RequestError < StandardError; end
    attr_reader :peer, :relationship

    def initialize(peer, relationship)
      @peer = peer
      @relationship = relationship.to_sym
    end

    def call!
      raise Error, "invalid relationship" if relationship_klass.blank?

      relationship_klass.new(request).call!
    end

    private
      def relationship_klass
        return @relationship_klass if defined? @relationship_klass
        relationship_table = {
          friendship_requested_by_me: "RequestFriendship",
          friendship_requested_by_me_blocked: "DeclineFriendship",
          full_block_by_me: "FullBlock",
          friend: "AcceptFriendship",
          unblock: "Unblock",
          unfriend: "Unfriend",
          cancel_friendship: "CancelFriendship"
        }

        klass = relationship_table[relationship]
        return nil if klass.blank?

        "PeersService::Relationships::#{klass}".constantize
      end

      def request
        @request ||= HttpService::ApiClient.new(
          url: peer.api_url("/instance/update_relationship"), method: :post,
          body: body, record: peer, peer: peer
        )
      end

      def remote_relationship
        relationship_table = {
          friendship_requested_by_me: :friendship_requested_by_external,
          friendship_requested_by_me_blocked: :friendship_requested_by_external_blocked,
          full_block_by_me: :full_block_by_external,
          friend: :friend,
          unblock: :unblock,
          unfriend: :unfriend,
          cancel_friendship: :cancel_friendship
        }

        relationship_table[relationship].tap do |rel|
          raise Error, "invalid relationship" if rel.blank?
        end
      end

      def body
        @body ||= {
          relationship: remote_relationship
        }
      end
  end
end
