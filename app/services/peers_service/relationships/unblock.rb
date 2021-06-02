# frozen_string_literal: true

module PeersService
  module Relationships
    class Unblock
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
          peer.status -= %i(full_block_by_me)
          peer.save!
        end

        def make_request!
          request.run

          if !request.valid? && request.safe_retry?
            raise UpdatePeerRelationship::RequestError, "Cannot accept friendship"
          end
        end
    end
  end
end
