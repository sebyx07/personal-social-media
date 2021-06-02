# frozen_string_literal: true

module PeersService
  module Relationships
    class RequestFriendship
      attr_reader :peer, :request

      def initialize(request)
        @request = request
        @peer = request.record
      end

      def call!
        make_request!
        update_peer!
      end

      private
        def update_peer!
          peer.status -= %i(stranger imported)
          peer.status << :friendship_requested_by_me
          peer.save!
        end

        def make_request!
          request.run

          if !request.valid? && request.safe_retry?
            raise UpdatePeerRelationship::RequestError, "Cannot request friendship"
          end
        end
    end
  end
end
