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
      raise "invalid relationship" if relationship_klass.blank?

      relationship_klass.new(peer).call!
    end

    private
      def relationship_klass
        return @relationship_klass if defined? !relationship_klass
        relationship_table = {
          "friendship_requested_by_me": "RequestFriendship"
        }

        klass = relationship_table[relationship]
        return nil if klass.blank?

        "PeersService::Relationships::#{klass}".constantize
      end
  end
end
